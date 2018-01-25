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
    
    func getWeekWeather(city: String, units: String) {
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        let param = ["q": city, "units": units, "appid": "0d56898a0da8944be0e2dff08367ac8c"]
        
        let weekWeather = WeekWeatherClass()
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON {[weak self] (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                weekWeather.cityName = json["city"]["name"].stringValue
                weekWeather.country = json["city"]["country"].stringValue
                
                for (_, subJson) in json["list"] {
                    var tmp = WeekWeatherDetailsClass()
                    
                    tmp.date = subJson["dt_txt"].stringValue
                    tmp.forecastedTime = subJson["dt"].doubleValue
                    tmp.humidity = subJson["main"]["humidity"].intValue
                    tmp.pressure = subJson["main"]["pressure"].doubleValue
                    tmp.temperatureMax = subJson["main"]["temp_max"].intValue
                    tmp.temperatureMin = subJson["main"]["temp_min"].intValue
                    tmp.weatherDescription = subJson["weather"][0]["description"].stringValue
                    tmp.weatherIcon = subJson["weather"][0]["icon"].stringValue
                    tmp.windDegrees = subJson["wind"]["deg"].doubleValue
                    tmp.windSpeed = subJson["wind"]["speed"].doubleValue
                    
                    weekWeather.weekWeatherDetails.append(tmp)
                }
//                print(weekWeather)
                do {
                    try realm.write {
                        realm.add(weekWeather, update: true)
                        self?.deleteOld()
                    }
                    print("week weather write")
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error as NSError):
                print(error.localizedDescription)
            }
        }
    }
    private func deleteOld() {
        let dateFormatter = DateFormatter()
        var today: String {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let today = NSDate()
            return dateFormatter.string(from: today as Date)
        }
        let yesterday = Date().timeIntervalSince1970 - (24*60*60)
        guard let itemsToDelete = realm.objects(WeekWeatherClass.self).first?.weekWeatherDetails.filter("forecastedTime < %@", yesterday) else { return }
        realm.delete(itemsToDelete)
    }
}













