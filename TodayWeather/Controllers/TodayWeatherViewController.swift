//
//  ViewController.swift
//  TodayWeather
//
//  Created by Sergey on 11.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit
import RealmSwift

class TodayWeatherViewController: UIViewController {
    var notificationToken: NotificationToken? = nil

    
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
    
    

    
    let cityName = "Taganrog"
    var units = "metric"
    lazy var manager = DataManagerSingleton.shared
    lazy var currentWeather = CurrentWeather()
    lazy var realmDataManager = RealmDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get data from server and save to realm DB
        // функция получает данные с сервера и созраняет в БД
        manager.getWeatherData(city: cityName, units: units)

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
        let realm = try! Realm()
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
        manager.getWeatherData(city: cityName, units: units)
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
        
        manager.getWeatherData(city: cityName, units: units)
    }
    
    @IBAction func unwindSegueWithoutData(segue: UIStoryboardSegue) { }
}










