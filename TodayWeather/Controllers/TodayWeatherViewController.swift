//
//  ViewController.swift
//  TodayWeather
//
//  Created by Sergey on 11.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

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
    
    

    
    var cityName: String?
    var country: String?
    var units = "metric"
    lazy var manager = DataManagerSingleton.shared
    lazy var currentWeather = CurrentWeather()
    lazy var realmDataManager = RealmDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get data from server and save to realm DB
        // функция получает данные с сервера и созраняет в БД
        manager.getWeatherData(city: "Taganrog", units: units)

        // realm notification watch for values, that change in DB
        // нотификация следит за изменениями в БД и выводит их в UI
        updateUI()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    //
    func changeUILabels() {
        
        // get current weather from DB
        let currentWeather = realmDataManager.getCurrentWeatherFromRealm().value(at: 0)
        print("Текущая погода: \(currentWeather)")
        // deactivate activity indicator when all data received
        // прячем activity indicator когда все все данные получены
        toggleActivityIndicator(on: false)
        
        if units == "metric" {
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
//                self?.changeUILabels()
            case .update(_, _, _, _):
                self?.changeUILabels()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    
    
    // MARK: Location manager methods
    
    
    // get current location coordinates
    func getCurrentLocation() {
        
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
        
        
        let lastLocation: CLLocation = locations.last!
        
        // if it location is nil or it has been moved
        if location == nil || location!.horizontalAccuracy > lastLocation.horizontalAccuracy {
            
            location = lastLocation
            
            locationManager.stopUpdatingLocation()
            
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
                
                self.parsePlacemarks()
            })
        }
    }
    
    
    func parsePlacemarks() {
        // here we check if location manager is not nil using a _ wild card
        if let _ = location {
            // unwrap the placemark
            if let placemark = placemark {
                // wow now you can get the city name. remember that apple refers to city name as locality not city
                // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                if let cityName = placemark.locality, !cityName.isEmpty {
                    // here you have the city name
                    // assign city name to our iVar
                    self.cityName = cityName
                }
                // get the country short name which is called isoCountryCode
                if let countryShortName = placemark.isoCountryCode, !countryShortName.isEmpty {
                    self.country = countryShortName
                }
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
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        // when user tapp on refresh button, activity indicator switch on and get new weather data from server. And then update UI.
        toggleActivityIndicator(on: true)
//        manager.getWeatherData(city: cityName, units: units)
        updateUI()
    }
    
    @IBAction func openSettingsScreen(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "settingsSegue" else { return }
        guard let destinationVC = segue.destination as? SettingsViewController else { return }
        destinationVC.units = units
        
    }
    
    
    
    @IBAction func unwindSegueWithData(segue: UIStoryboardSegue) {
        
        guard let sourceViewController = segue.source as? SettingsViewController else { return }
        guard let svcUnits = sourceViewController.units else { return }
        units = svcUnits
        
//        manager.getWeatherData(city: cityName, units: units)
    }
    
    @IBAction func unwindSegueWithoutData(segue: UIStoryboardSegue) { }
}










