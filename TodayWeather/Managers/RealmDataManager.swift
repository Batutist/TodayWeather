//
//  RealmDataManager.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataManager {
    // get current weather from DB
    func getCurrentWeatherFromDB() -> CurrentWeather {

            let currentWeatherClass = realm.objects(CurrentWeatherClass.self)
        
            var currentWeather = CurrentWeather()

            for value in currentWeatherClass {
                currentWeather.cityName = value.cityName
                currentWeather.cityCountry = value.cityCountry
                currentWeather.cityTemperature = value.cityTemperature
                currentWeather.cityWindSpeed = value.cityWindSpeed
                currentWeather.cityPressure = value.cityPressure
                currentWeather.cityHumidity = value.cityHumidity
                currentWeather.cityTemperatureMin = value.cityTemperatureMin
                currentWeather.cityTemperatureMax = value.cityTemperatureMax
                currentWeather.cityWeatherDescription = value.cityWeatherDescription
                currentWeather.cityWeatherIcon = value.cityWeatherIcon
            }

            return currentWeather

    }
    
    func getCurrentWeatherFromRealm(cityName: String) -> FetchedResults<CurrentWeather> {
        
        let container = Container(realm: realm)
        let currentWeather = container.values(CurrentWeather.self, matching: .cityName(cityName))
        
        return currentWeather
    }
    
}
