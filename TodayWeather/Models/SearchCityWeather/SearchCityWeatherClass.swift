//
//  SearchCityWeatherClass.swift
//  TodayWeather
//
//  Created by Sergey on 23.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class SearchCityWeatherClass: Object {
    
    @objc dynamic var cityName: String = ""
    @objc dynamic var cityCountry: String = ""
    @objc dynamic var cityTemperature: Int = 0
    @objc dynamic var cityWindSpeed: Double = 0.0
    @objc dynamic var cityPressure: Double = 0.0
    @objc dynamic var cityHumidity: Int = 0
    @objc dynamic var cityTemperatureMin: Int = 0
    @objc dynamic var cityTemperatureMax: Int = 0
    @objc dynamic var cityWeatherDescription: String = ""
    @objc dynamic var cityWeatherIcon: String = ""
    
    override static func primaryKey() -> String {
        return "cityName"
    }
}
