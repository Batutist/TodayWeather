//
//  SearchCityWeather.swift
//  TodayWeather
//
//  Created by Sergey on 23.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation

struct SearchCityWeather {
    
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

extension SearchCityWeather {
    
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
extension SearchCityWeather {
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
extension SearchCityWeather {
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

extension SearchCityWeather {
    
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

extension SearchCityWeather: Persistable {
    
    init(mangedObject: SearchCityWeatherClass) {
        
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
    
    func toManagedObject() -> SearchCityWeatherClass {
        let searchCityWeatherClass = SearchCityWeatherClass()
        
        searchCityWeatherClass.cityName = cityName
        searchCityWeatherClass.cityCountry = cityCountry
        searchCityWeatherClass.cityTemperature = cityTemperature
        searchCityWeatherClass.cityWindSpeed = cityWindSpeed
        searchCityWeatherClass.cityPressure = cityPressure
        searchCityWeatherClass.cityHumidity = cityHumidity
        searchCityWeatherClass.cityTemperatureMin = cityTemperatureMin
        searchCityWeatherClass.cityTemperatureMax = cityTemperatureMax
        searchCityWeatherClass.cityWeatherDescription = cityWeatherDescription
        searchCityWeatherClass.cityWeatherIcon = cityWeatherIcon
        
        return searchCityWeatherClass
    }
}











