//
//  TodayWeathe.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation

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
    
    var cityAndCountryName: String {
        return cityName + ", " + cityCountry
    }
    var cityPressureString: String {
        return "\(cityPressure) mb"
    }
    var cityHumidityString: String {
        return "\(cityHumidity)%"
    }
}

// extension for Metric units
extension CurrentWeather {
    var temperatureMetricString: String {
        return "\(cityTemperature)˚"
    }
    var cityTemperatureMaxMetricString: String {
        return "\(cityTemperatureMax)˚"
    }
    var cityTemperatureMinMetricString: String {
        return "\(cityTemperatureMin)˚"
    }
    var cityWindSpeedMetricString: String {
        return "\(cityWindSpeed) m/s"
    }

}

// extension for Imperial units
extension CurrentWeather {
    var temperatureImperialString: String {
        return "\(cityTemperature)F"
    }
    var cityTemperatureMaxImperialString: String {
        return "\(cityTemperatureMax)˚F"
    }
    var cityTemperatureMinImperialString: String {
        return "\(cityTemperatureMin)˚F"
    }
    var cityWindSpeedImperialString: String {
        return "\(cityWindSpeed) mil/h"
    }
}


extension CurrentWeather {
    
    public enum Query: QueryType {
        case cityName(String)
        
        public var predicate: NSPredicate? {
            switch self {
            case .cityName(let cityName):
                return NSPredicate(format: "cityName == %@", cityName)
            }
        }
    }
}

extension CurrentWeather: Persistable {
    
    init(mangedObject: CurrentWeatherClass) {
        
        cityName = mangedObject.cityName
        cityCountry = mangedObject.cityCountry
        cityTemperature = mangedObject.cityTemperature
        cityWindSpeed = mangedObject.cityWindSpeed
        cityPressure = mangedObject.cityPressure
        cityHumidity = mangedObject.cityHumidity
        cityTemperatureMin = mangedObject.cityTemperatureMin
        cityTemperatureMax = mangedObject.cityTemperatureMax
        cityWeatherDescription = mangedObject.cityWeatherDescription
        cityWeatherIcon = mangedObject.cityWeatherIcon
        
    }
    
    func toManagedObject() -> CurrentWeatherClass {
        let currentWeatherClass = CurrentWeatherClass()
        
        currentWeatherClass.cityName = cityName
        currentWeatherClass.cityCountry = cityCountry
        currentWeatherClass.cityTemperature = cityTemperature
        currentWeatherClass.cityWindSpeed = cityWindSpeed
        currentWeatherClass.cityPressure = cityPressure
        currentWeatherClass.cityHumidity = cityHumidity
        currentWeatherClass.cityTemperatureMin = cityTemperatureMin
        currentWeatherClass.cityTemperatureMax = cityTemperatureMax
        currentWeatherClass.cityWeatherDescription = cityWeatherDescription
        currentWeatherClass.cityWeatherIcon = cityWeatherIcon
        
        return currentWeatherClass
    }
}


