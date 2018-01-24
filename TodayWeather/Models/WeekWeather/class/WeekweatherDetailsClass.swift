//
//  WeekweatherDetailsClass.swift
//  TodayWeather
//
//  Created by Sergey on 24.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class WeekWeatherDetailsClass: Object {
    
    @objc dynamic var forecastedTime = 0.0
    @objc dynamic var date = ""
    @objc dynamic var temperatureMax = 0
    @objc dynamic var weatherIcon = ""
    @objc dynamic var temperatureMin = 0
    @objc dynamic var weatherDescription = ""
    @objc dynamic var windSpeed = 0.0
    @objc dynamic var windDegrees = 0.0
    @objc dynamic var humidity = 0
    @objc dynamic var pressure = 0.0
    
    override static func primaryKey() -> String {
        return "date"
    }
}
