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

extension WeekWeatherDetailsClass {
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: forecastedTime)
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date as Date)
    }
    
    var humidityString: String {
        return "\(humidity)%"
    }
    
    var pressureString: String {
        return "\(pressure)mb"
    }
    
    var temperatureMaxString: String {
        return "\(temperatureMax)˚"
    }
    var temperatureMinString: String {
        return "\(temperatureMin)˚"
    }
    var windSpeedString: String {
        return "\(windSpeed)m/s"
    }
    
    
    static private func dayOfWeekFunc(forecastedTime: Double) -> Int {
        
        let date = Date(timeIntervalSince1970: forecastedTime)
        
        let gregorian : NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let weekdayComponent : NSDateComponents = gregorian.components(.weekday, from: date as Date) as NSDateComponents
        
        let currentDay = weekdayComponent.weekday - 1 //адаптируем календарь под отечественный
        return currentDay
    }
    
    
    var dayOfWeek: String {
        let dayNumber = WeekWeatherDetailsClass.dayOfWeekFunc(forecastedTime: forecastedTime)
        switch dayNumber {
        case 1:
            return "Mon"
        case 2:
            return "Tue"
        case 3:
            return "Wed"
        case 4:
            return "Thu"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        case 0:
            return "Sun"
        default:
            print("Can't get day of the week")
            return "Nil"
        }
    }
    
    var windDegreesString: String {
        switch windDegrees {
        case 0 ..< 11.25:
            return "N"
        case 11.25 ..< 33.75:
            return "NNE"
        case 33.75 ..< 56.25:
            return "NE"
        case 56.25 ..< 78.75:
            return "ENE"
        case 78.75 ..< 101.25:
            return "E"
        case 10.25 ..< 123.75:
            return "ESE"
        case 123.75 ..< 146.25:
            return "SE"
        case 146.25 ..< 168.75:
            return "SSE"
        case 168.75 ..< 191.25:
            return "S"
        case 191.25 ..< 213.75:
            return "SSW"
        case 213.75 ..< 236.25:
            return "SW"
        case 236.25 ..< 258.75:
            return "WSW"
        case 258.75 ..< 281.25:
            return "W"
        case 281.25 ..< 303.75:
            return "WNW"
        case 303.75 ..< 326.25:
            return "NW"
        case 326.25 ..< 348.75:
            return "NWN"
        case 348.75 ..< 359.99:
            return "N"
        default:
            return "nil"
        }
    }
}
