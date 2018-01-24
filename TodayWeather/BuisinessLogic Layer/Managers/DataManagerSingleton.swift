//
//  DataManager.swift
//  TodayWeather
//
//  Created by Sergey on 16.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift



final class DataManagerSingleton {
    
    static let shared = DataManagerSingleton()
    
    private init() {}
    
    func getWeatherData(city: String, units: String) {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let param =  ["q": city, "units": units, "appid": "0d56898a0da8944be0e2dff08367ac8c"]
        var currentWeather = CurrentWeather()
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                currentWeather = CurrentWeather(
                    cityName: json["name"].stringValue,
                    cityCountry: json["sys"]["country"].stringValue,
                    cityTemperature: json["main"]["temp"].intValue,
                    cityWindSpeed: json["wind"]["speed"].doubleValue,
                    cityPressure: json["main"]["pressure"].doubleValue,
                    cityHumidity: json["main"]["humidity"].intValue,
                    cityTemperatureMin: json["main"]["temp_min"].intValue,
                    cityTemperatureMax: json["main"]["temp_max"].intValue,
                    cityWeatherDescription: json["weather"][0]["description"].stringValue,
                    cityWeatherIcon: json["weather"][0]["icon"].stringValue)
                
                do {
                    let container = try Container()
                    try container.write({ (transaction) in
                        transaction.add(currentWeather, update: true)
                    })
                    
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
                
                print("JSON: \(currentWeather)")
                userDefaults.set(true, forKey: "Load")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSearchCityWeatherData(searchCity: String, units: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let param =  ["q": searchCity, "units": units, "appid": "0d56898a0da8944be0e2dff08367ac8c"]
        var searchCityWeather = SearchCityWeather()
        
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                searchCityWeather = SearchCityWeather(
                    cityName: json["name"].stringValue,
                    cityCountry: json["sys"]["country"].stringValue,
                    cityTemperature: json["main"]["temp"].intValue,
                    cityWindSpeed: json["wind"]["speed"].doubleValue,
                    cityPressure: json["main"]["pressure"].doubleValue,
                    cityHumidity: json["main"]["humidity"].intValue,
                    cityTemperatureMin: json["main"]["temp_min"].intValue,
                    cityTemperatureMax: json["main"]["temp_max"].intValue,
                    cityWeatherDescription: json["weather"][0]["description"].stringValue,
                    cityWeatherIcon: json["weather"][0]["icon"].stringValue
                )
                
                do {
                    let container = try Container()
                    try container.write({ (transaction) in
                        transaction.add(searchCityWeather, update: true)
                    })
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
                userDefaults.set(true, forKey: "LoadSearchCityWeather")
                print("JSON: \(searchCityWeather)")
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}