//
//  TodayWeathe.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

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

extension CurrentWeather {
    
    public enum PropertyValue: PropertyValueType {
        case cityName(String)
        case cityCountry(String)
        case cityTemperature(Int)
        case cityWindSpeed(Double)
        case cityPressure(Double)
        case cityHumidity(Int)
        case cityTemperatureMin(Int)
        case cityTemperatureMax(Int)
        case cityWeatherDescription(String)
        case cityWeatherIcon(String)
        
        
        public var propertyValuePair: PropertyValuePair {
            switch self {
            case .cityName(let cityName):
                return ("cityName", cityName)
            case .cityCountry(let cityCountry):
                return ("cityCountry", cityCountry)
            case .cityTemperature(let temperature):
                return ("cityTemperature", temperature)
            case .cityWindSpeed(let cityWindSpeed):
                return ("cityWindSpeed", cityWindSpeed)
            case .cityPressure(let cityPressure):
                return ("cityPressure", cityPressure)
            case .cityHumidity(let cityHumidity):
                return ("cityHumidity", cityHumidity)
            case .cityTemperatureMin(let cityTemperatureMin):
                return ("cityTemperatureMin", cityTemperatureMin)
            case .cityTemperatureMax(let cityTemperatureMax):
                return ("cityTemperatureMax", cityTemperatureMax)
            case .cityWeatherDescription(let cityWeatherDescription):
                return ("cityWeatherDescription", cityWeatherDescription)
            case .cityWeatherIcon(let cityWeatherIcon):
                return ("cityWeatherIcon", cityWeatherIcon)
            }
        }
    }
}
//extension CurrentWeather: ManagedObjectConvertible {
//
//    func toManagedObject(object: Realm) -> CurrentWeatherClass? {
//        guard let currentWeatherClass = CurrentWeatherClass.getObject(from: object) ?? CurrentWeatherClass.createObjectInRealm(object) else { return nil }
//
//        currentWeatherClass.cityName = cityName
//        currentWeatherClass.cityCountry = cityCountry
//        currentWeatherClass.cityTemperature = cityTemperature
//        currentWeatherClass.cityWindSpeed = cityWindSpeed
//        currentWeatherClass.cityPressure = cityPressure
//        currentWeatherClass.cityHumidity = cityHumidity
//        currentWeatherClass.cityTemperatureMin = cityTemperatureMin
//        currentWeatherClass.cityTemperatureMax = cityTemperatureMax
//        currentWeatherClass.cityWeatherDescription = cityWeatherDescription
//        currentWeatherClass.cityWeatherIcon = cityWeatherIcon
//
//        return currentWeatherClass
//    }
//
//}


