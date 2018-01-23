//
//  SearchCityViewController.swift
//  TodayWeather
//
//  Created by Sergey on 23.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SearchCityWeatherViewController: UIViewController {
    var notificationToken: NotificationToken? = nil
    
    lazy var manager = DataManagerSingleton.shared
    lazy var realmDataManager = RealmDataManager()
    lazy var searchCityWeather = SearchCityWeather()
    
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var searchCityButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTemperatureLabel: UILabel!
    @IBOutlet weak var cityWeatherIcon: UIImageView!
    @IBOutlet weak var cityWeatherDescription: UILabel!
    @IBOutlet weak var cityTemperatureMaxLabel: UILabel!
    @IBOutlet weak var cityTemperatureMinLabel: UILabel!
    @IBOutlet weak var cityWindSpeedLabel: UILabel!
    @IBOutlet weak var cityPressureLabel: UILabel!
    @IBOutlet weak var cityHumidityLabel: UILabel!
    
    let defaultCity = "Taganrog"
    var searchCity: String!
//    var units = userDefaults.string(forKey: "units")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("search city now is: \(searchCity)")
        print("units now are: \(units)")
//        if searchCity == nil {
//            searchCity = defaultCity
//        }
        
        manager.getSearchCityWeatherData(searchCity: searchCity ?? defaultCity, units: units)
        
        updateUI()
    }
    
    
    func changeLabelsAndImages() {
        let searchCity = self.searchCity ?? userDefaults.string(forKey: "lastSearchCity")
        print("now search by: \(searchCity)!")
        let searchCityWeather = realmDataManager.getSearchCityWeatherFromRealm(searchCityName: searchCity ?? defaultCity).value(at: 0)
        print("weather is: \(searchCityWeather)")
        
        if units == "metric" {
            cityTemperatureLabel.text = searchCityWeather.temperatureMetricString
            cityTemperatureMaxLabel.text = searchCityWeather.cityTemperatureMaxMetricString
            cityTemperatureMinLabel.text = searchCityWeather.cityTemperatureMinMetricString
            cityWindSpeedLabel.text = searchCityWeather.cityWindSpeedMetricString
        } else {
            cityTemperatureLabel.text = searchCityWeather.temperatureImperialString
            cityTemperatureMaxLabel.text = searchCityWeather.cityTemperatureMaxImperialString
            cityTemperatureMinLabel.text = searchCityWeather.cityTemperatureMinImperialString
            cityWindSpeedLabel.text = searchCityWeather.cityWindSpeedImperialString
        }
        cityNameLabel.text = searchCityWeather.cityAndCountryName
        cityWeatherIcon.image = UIImage(named: searchCityWeather.cityWeatherIcon)
        cityWeatherDescription.text = searchCityWeather.cityWeatherDescription
        cityPressureLabel.text = searchCityWeather.cityPressureString
        cityHumidityLabel.text = searchCityWeather.cityHumidityString
    }
    
    func updateUI() {
        
        let results = realm.objects(SearchCityWeatherClass.self)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("new")
            case .update(_, _, _, _):
                self?.changeLabelsAndImages()
                print("update")
                
            case .error(let error as NSError):
                print("error is: \(error.localizedDescription)")
                fatalError("\(error)")
            }
        }
    }
    
    
    deinit {
        notificationToken?.invalidate()
    }
    // func with alert controller to display if citySearchTextField is empty
    // функция с всплывающей ошибкой в случае пустого citySearchTextField
    func errorAlertController(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OK)
        present(alertController, animated: true, completion: nil)
    }
    

    
    
    @IBAction func searchCityButtonTapped(_ sender: UIButton) {
        // check citySearchTextField on validation
        // проверяем валидность введеной информации в citySearchTextField
        guard let searchCity = searchCityTextField.text, searchCity != "" else {
            errorAlertController(message: "You don't enter city name")
            return
        }
        guard searchCity.count >= 3 else {
            errorAlertController(message: "You must enter at least 3 characters.")
            return
        }
        guard searchCity.last != " " else {
            print("Here is our variant: \(searchCity)!")
            let searchCityWithoutSpace = String(searchCity.dropLast().capitalized)
            print("And now: \(searchCityWithoutSpace)!")
            userDefaults.set(searchCityWithoutSpace, forKey: "lastSearchCity")
            self.searchCity = searchCityWithoutSpace
            manager.getSearchCityWeatherData(searchCity: searchCityWithoutSpace, units: units)
            updateUI()
            view.endEditing(true)
            return
        }
        self.searchCity = searchCity.capitalized
        userDefaults.set(searchCity.capitalized, forKey: "lastSearchCity")
        manager.getSearchCityWeatherData(searchCity: searchCity, units: units)
        
        updateUI()
        // hide keyboard when button is pressed
        // скрываем клавиатуру по нажатию на кнопку поиск
        view.endEditing(true)
    }
}
