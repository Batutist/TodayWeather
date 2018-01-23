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
    
    var defaultCity = "Taganrog"
    var cityName: String?
    var country: String?
    var units = userDefaults.string(forKey: "units")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getSearchCityWeatherData(searchCity: defaultCity, units: "metric")
    }
    
    
    
    // func with alert controller to display if citySearchTextField is empty
    // функция с всплывающей ошибкой в случае пустого citySearchTextField
    func dontEnterCityName() {
        let alertController = UIAlertController(title: "Ошибка", message: "Вы не ввели имя города.", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OK)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func searchCityButtonTapped(_ sender: UIButton) {
        
        // check citySearchTextField on validation
        // проверяем валидность введеной информации в citySearchTextField
        
        if let searchCity = searchCityTextField.text, searchCity != "" {
            
            //            manager.loadJSONSearch(city: searchCity)
            // call func to update user interface
            // вызываем функцию для обновления отображаемых данных
            //            updateUI()
        } else {
            dontEnterCityName()
        }
        // hide keyboard when button is pressed
        // скрываем клавиатуру по нажатию на кнопку поиск
        view.endEditing(true)
    }
}
