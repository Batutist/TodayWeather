//
//  DataManager.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift





class DataManager {
    
    func getWeatherData(city: String) {
        let realm = try! Realm()
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let param =  ["q": city, "units": "metric", "appid": "0d56898a0da8944be0e2dff08367ac8c"]
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
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
                
                
                
                
                //                do {
                //                    try realm.write {
                ////                        guard let currentWeatherClass = currentWeather.toManagedObject(object: realm) else { print("nil")
                //                            return }
                //                        realm.add(currentWeatherClass, update: true)
                //                        print("Success")
                //                        print(Realm.Configuration.defaultConfiguration.fileURL!)
                //                    }
                //                } catch(let error) {
                //                    print(error.localizedDescription)
                //                }
                
                print("JSON: \(currentWeather)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //    private func fromStructToClass(currentWeather: CurrentWeather, currentWeatherClass: CurrentWeatherClass) {
    //
    //        currentWeatherClass.cityName = currentWeather.cityName
    //        currentWeatherClass.cityCountry = currentWeather.cityCountry
    //        currentWeatherClass.cityTemperature = currentWeather.cityTemperature
    //        currentWeatherClass.cityWindSpeed = currentWeather.cityWindSpeed
    //        currentWeatherClass.cityPressure = currentWeather.cityPressure
    //        currentWeatherClass.cityHumidity = currentWeather.cityHumidity
    //        currentWeatherClass.cityTemperatureMin = currentWeather.cityTemperatureMin
    //        currentWeatherClass.cityTemperatureMax = currentWeather.cityTemperatureMax
    //        currentWeatherClass.cityWeatherDescription = currentWeather.cityWeatherDescription
    //        currentWeatherClass.cityWeatherIcon = currentWeather.cityWeatherIcon
    //
    //    }
}


//var cityWeatherIcon = WeatherIconManager(rawValue: "01d")
