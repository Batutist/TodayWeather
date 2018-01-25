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
    
    lazy var manager = DataManagerSingleton.shared
//    lazy var currentWeather = CurrentWeather()
    lazy var realmDataManager = RealmDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Location manager singleton
        let LocationManager = UserLocationManager.SharedManager
        
        toggleActivityIndicator(on: true)
        print("load from here")
        // Get current coordiantes, parse them to location city & country name.
        // Load weather data by new location
        manager.getWeatherData(city: currentCityName ?? defaultCity, units: units)
        // realm notification watch for values, that change in DB
        // нотификация следит за изменениями в БД и выводит их в UI
        updateUI()
    }
    
    
    deinit {
        notificationToken?.invalidate()
    }
    //
    func changeUILabels() {
        let cityName = currentCityName ?? defaultCity
        print("City value now is: \(cityName)")
        // get current weather from DB
        let currentWeather = realmDataManager.getCurrentWeatherFromRealm(cityName: cityName).value(at: 0)
        print("Текущая погода: \(currentWeather)")
        
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
        cityNameLabel.text = currentWeather.cityAndCountryName
        weatherIcon.image = UIImage(named: currentWeather.cityWeatherIcon)
        weatherDescriptionLabel.text = currentWeather.cityWeatherDescription
        pressureLabel.text = currentWeather.cityPressureString
        humidityLabel.text = currentWeather.cityHumidityString
        
        // deactivate activity indicator when all data received
        // прячем activity indicator когда все все данные получены
        toggleActivityIndicator(on: false)
    }
    // realm notification
    func updateUI() {
        // observe for changes in results
        let results = realm.objects(CurrentWeatherClass.self)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("new")
            case .update(_, _, _, _):
                self?.changeUILabels()
                print("update")
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
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
        let cityAndCountryName = (currentCityName ?? "Taganrog") + ", " + (currentCountry ?? "RU")
        manager.getWeatherData(city: cityAndCountryName, units: units)
        
        updateUI()
    }
}










