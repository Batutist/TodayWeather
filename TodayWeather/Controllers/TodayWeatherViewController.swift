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
    lazy var manager = DataManager()
    lazy var currentWeather = CurrentWeather()
    lazy var realmDataManager = RealmDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get data from server and 
        manager.getWeatherData(city: cityName)
        updateUI()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func changeUILabels() {
        let currentWeather = realmDataManager.getCurrentWeatherFromDB()
        toggleActivityIndicator(on: false)
        weatherIcon.image = UIImage(named: currentWeather.cityWeatherIcon)
        temperatureLabel.text = currentWeather.temperatureString
        weatherDescriptionLabel.text = currentWeather.cityWeatherDescription
        temperatureMinLabel.text = currentWeather.cityTemperatureMinString
        temperatureMaxLabel.text = currentWeather.cityTemperatureMaxString
        windSpeedLabel.text = currentWeather.cityWindSpeedString
        pressureLabel.text = currentWeather.cityPressureString
        humidityLabel.text = currentWeather.cityHumidityString

    }
    
    func updateUI() {
        
        let results = realm.objects(CurrentWeatherClass.self)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.changeUILabels()
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
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        manager.getWeatherData(city: cityName)
        updateUI()
    }
    
}










