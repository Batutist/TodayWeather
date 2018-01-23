//
//  ViewController.swift
//  TodayWeather
//
//  Created by Sergey on 11.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift
import CoreLocation

class TodayWeatherViewController: UIViewController, CLLocationManagerDelegate {
    var notificationToken: NotificationToken? = nil
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var latitude: Double = 0
    var longitude: Double = 0
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!

    var defaultCity = "Taganrog"
    var cityName: String?
    var country: String?
//    var units = userDefaults.string(forKey: "units")
    
    lazy var manager = DataManagerSingleton.shared
    lazy var currentWeather = CurrentWeather()
    lazy var realmDataManager = RealmDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get users permission for work with his location
        locationManager.requestWhenInUseAuthorization()
        toggleActivityIndicator(on: true)
        // If userDefault for "Load" == false load data for deafault city.
        // Else load data for city which is determined from the coordinates
        if userDefaults.bool(forKey: "Load") {
            print("load from here")
            // Get current coordiantes, parse them to location city & country name.
            // Load weather data by new location
            getWeatherByCurrentLocation()
        } else {
            // get data from server and save to realm DB
            // функция получает данные с сервера и созраняет в БД
            print("first load")
            manager.getWeatherData(city: defaultCity, units: units)
        }
        // realm notification watch for values, that change in DB
        // нотификация следит за изменениями в БД и выводит их в UI
        updateUI()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    //
    func changeUILabels() {
        let cityName = self.cityName ?? defaultCity
        print("City value now is: \(cityName)")
        // get current weather from DB
        let currentWeather = realmDataManager.getCurrentWeatherFromRealm(cityName: cityName).value(at: 0)
        print("Текущая погода: \(currentWeather)")
        // deactivate activity indicator when all data received
        // прячем activity indicator когда все все данные получены
        toggleActivityIndicator(on: false)

        if units == "metric" || units == nil {
            temperatureLabel.text = currentWeather.temperatureMetricString
            temperatureMinLabel.text = currentWeather.cityTemperatureMinMetricString
            temperatureMaxLabel.text = currentWeather.cityTemperatureMaxMetricString
            windSpeedLabel.text = currentWeather.cityWindSpeedMetricString
        } else {
            temperatureLabel.text = currentWeather.temperatureImperialString
            temperatureMinLabel.text = currentWeather.cityTemperatureMinImperialString
            temperatureMaxLabel.text = currentWeather.cityTemperatureMaxImperialString
            windSpeedLabel.text = currentWeather.cityWindSpeedImperialString
        }
        // show received values in UI
        // выводим полученные значения в пользовательский интерфейс
        cityNameLabel.text = currentWeather.cityAndCountryName
        weatherIcon.image = UIImage(named: currentWeather.cityWeatherIcon)
        weatherDescriptionLabel.text = currentWeather.cityWeatherDescription
        pressureLabel.text = currentWeather.cityPressureString
        humidityLabel.text = currentWeather.cityHumidityString

    }
    // realm notification
    func updateUI() {
        // observe for changes in results
        let results = realm.objects(CurrentWeatherClass.self)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("new")
                self?.changeUILabels()
            case .update(_, _, _, _):
                self?.changeUILabels()
                print("update")
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    
    
    // MARK: Location manager methods
    // get current location coordinates
    func getWeatherByCurrentLocation() {
        guard CLLocationManager.locationServicesEnabled() == true else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        let authStatus = CLLocationManager.authorizationStatus()
        
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                    "go to Settings → GeoExample → Location and select the \"While Using " +
                    "the App\" setting.")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // This method is called if:
    // - the location manager is updating, and
    // - it was able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the last user location
        let lastLocation: CLLocation = locations.last!
        
        // if it location is nil or it has been moved
        if location == nil || location!.horizontalAccuracy > lastLocation.horizontalAccuracy {
            
            location = lastLocation
            print("lat is:\(location?.coordinate.latitude) lon is:\(location?.coordinate.longitude)")
            
            // Stop updating location
            locationManager.stopUpdatingLocation()
            
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
                 // Get city and county name from coordinates
                self.parsePlacemarks()
            })
        }
    }
    
    // Get city and county name from coordinates
    func parsePlacemarks() {
        // Check if location manager is not nil
        if let _ = location {
            // Unwrap the placemark
            if let placemark = placemark {
                // Unwrap the locality
                if let cityName = placemark.locality, !cityName.isEmpty, let countryShortName = placemark.isoCountryCode, !countryShortName.isEmpty {
                    // assign city name to our iVar
                    self.cityName = cityName.folding(options: .diacriticInsensitive, locale: .current)
                    self.country = countryShortName
                    let cityAndCountryName = cityName + ", " + countryShortName
                    // Get weather data by new location
                    manager.getWeatherData(city: cityAndCountryName, units: units)
                }
                print("current location city is: \(cityName) & country: \(country)")
            }
        } else {
            // add some more check's if for some reason location manager is nil
        }
    }
    
    // This is called if:
    // - the location manager is updating, and
    // - it WASN'T able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    // State of activity indicator
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
            refreshButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            refreshButton.isEnabled = true
        }
    }
    
    // Refresh button tapped
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        // when user tapp on refresh button, activity indicator switch on and get new weather data from server. And then update UI.
        toggleActivityIndicator(on: true)
        let cityAndCountryName = cityName! + ", " + country!
        manager.getWeatherData(city: cityAndCountryName, units: units)
        getWeatherByCurrentLocation()
        updateUI()
    }
    
//    // Works when user tapp on settings button
//    @IBAction func openSettingsScreen(_ sender: UIButton) {
//    }
//
//    // Transfer current units value to SettingsViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "settingsSegue" else { return }
//        guard let destinationVC = segue.destination as? SettingsViewController else { return }
//        destinationVC.units = units
//
//    }
//
//
//    // Unwind segue from SettingsViewController with saving data
//    @IBAction func unwindSegueWithData(segue: UIStoryboardSegue) {
//        toggleActivityIndicator(on: true)
//        guard let sourceViewController = segue.source as? SettingsViewController else { return }
//        guard let svcUnits = sourceViewController.units else { return }
//        units = svcUnits
//
//        guard let cityName = cityName, let country = country else { return }
//        let cityAndCountryName = cityName + ", " + country
//        manager.getWeatherData(city: cityAndCountryName, units: units ?? "metric")
//        updateUI()
//    }
//
//    // Unwind segue without data saving
//    @IBAction func unwindSegueWithoutData(segue: UIStoryboardSegue) { }
}










