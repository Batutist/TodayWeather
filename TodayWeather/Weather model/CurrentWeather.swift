//
//  TodayWeathe.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    
    var cityName = ""
    var cityCountry = ""
    var cityTemperature = 0
    var cityWindSpeed = 0.0
    var cityPressure = 0.0
    var cityHumidity = 0
    var cityTemperatureMin = 0
    var cityTemperatureMax = 0
    var cityWeatherDescription = ""
    var cityWeatherIcon = ""

}

extension CurrentWeather {
    var temperatureString: String {
        return "\(cityTemperature)˚"
    }
    var cityTemperatureMaxString: String {
        return "\(cityTemperatureMax)˚"
    }
    var cityTemperatureMinString: String {
        return "\(cityTemperatureMin)"
    }
    var cityWindSpeedString: String {
        return "\(cityWindSpeed) km/h"
    }
    var cityPressureString: String {
        return "\(cityPressure) mb"
    }
    var cityHumidityString: String {
        return "\(cityHumidity)%"
    }
}
