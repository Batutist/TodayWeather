//
//  SearchCityViewController.swift
//  TodayWeather
//
//  Created by Sergey on 23.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import UIKit

class SearchCityWeatherViewController: UIViewController {
    
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
        if searchCityTextField.text == "" || searchCityTextField.text == nil {
            dontEnterCityName()             /* func with alertController */
        } else {
            // if everything is ok transfer city name from citySearchTextField to func loadJSONSearch
            // если все ок, то передаем название города из citySearchTextField в loadJSONSearch функцию
            let searchCity = searchCityTextField.text!
//            manager.loadJSONSearch(city: searchCity)
            // call func to update user interface
            // вызываем функцию для обновления отображаемых данных
//            updateUI()
        }
        // hide keyboard when button is pressed
        // скрываем клавиатуру по нажатию на кнопку поиск
        view.endEditing(true)
    }
}
