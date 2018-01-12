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
    
//    var cityName: String
//    var cityCountry: String
//    var cityTemperature: Int
//    var cityWindSpeed: Double
//    var cityPressure: Double
//    var cityHumidity: Int
//    var cityTemperatureMin: Int
//    var cityTemperatureMax: Int
//    var cityWeatherDescription: String
//    var cityWeatherIcon: String
    
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

//extension CurrentWeather: JSONDecodable {
//    init?(JSON: [String : AnyObject]) {
//        guard let cityTemperature = JSON["temp"] as? Int,
//            let cityPressure = JSON["pressure"] as? Double,
//            let cityHumidity = JSON["humidity"] as? Int,
//            let cityTemperatureMin = JSON["temp_min"] as? Int,
//            let cityTemperatureMax = JSON["temp_max"] as? Int else { return nil }
//        guard let cityName = JSON["name"] as? String,
//            let cityCountry = JSON["sys"]["country"] as? String,
//            let cityTemperature = main!["temp"] as? Int,
//            let cityWindSpeed = JSON["wind"]!["speed"] as? Double,
//            let cityPressure = JSON["main"]!["pressure"] as? Double,
//            let cityHumidity = JSON["main"]!["humidity"] as? Int,
//            let cityTemperatureMin = JSON["main"]!["temp_min"] as? Int,
//            let cityTemperatureMax = JSON["main"]!["temp_max"] as? Int,
//            let cityweatherDescription = (JSON["weather"]!["description"]) as? String,
//            let cityWeahterIconString = JSON["weather"]![0]["icon"] as? String else { return nil }
//
//        var cityWeatherIcon = WeatherIconManager(rawValue: "01d")
//
//        cityName = "Taganrog"
//        cityCountry = "RU"
//        cityWindSpeed = 10
//        cityWeatherDescription = "Clear"
//        cityWeatherIcon = UIImage(named: "01d")!
//        self.cityName = cityName
//        self.cityCountry = cityCountry
//        self.cityTemperature = cityTemperature
//        self.cityWindSpeed = cityWindSpeed
//        self.cityPressure = cityPressure
//        self.cityHumidity = cityHumidity
//        self.cityTemperatureMin = cityTemperatureMin
//        self.cityTemperatureMax = cityTemperatureMax
//        self.cityWeatherDescription = cityweatherDescription
//        self.cityWeatherIcon = cityWeatherIcon
//    }
//}

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
