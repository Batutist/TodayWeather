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
    
    
    static func dayOfWeek(forecastedTime: Double) -> Int {
        
        let date = Date(timeIntervalSince1970: forecastedTime)
        
        let gregorian : NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let weekdayComponent : NSDateComponents = gregorian.components(.weekday, from: date as Date) as NSDateComponents
        
        let currentDay = weekdayComponent.weekday - 1 //адаптируем календарь под отечественный
        return currentDay
    }
    
    var dayOfWeek: String {
        var dayOfWeekString = ""
        if WeekWeatherDetailsClass.dayOfWeek(forecastedTime: forecastedTime) == 1 {
            dayOfWeekString = ("Mon")
        } else if WeekWeatherDetailsClass.dayOfWeek(forecastedTime: forecastedTime) == 2 {
            dayOfWeekString = ("Tue")
        } else if WeekWeatherDetailsClass.dayOfWeek(forecastedTime: forecastedTime) == 3 {
            dayOfWeekString = ("Wed")
        } else if WeekWeatherDetailsClass.dayOfWeek(forecastedTime: forecastedTime) == 4 {
            dayOfWeekString = ("Thu")
        } else if WeekWeatherDetailsClass.dayOfWeek(forecastedTime: forecastedTime) == 5 {
            dayOfWeekString = ("Fri")
        } else if WeekWeatherDetailsClass.dayOfWeek(forecastedTime: forecastedTime) == 6 {
            dayOfWeekString = ("Sat")
        } else {
            dayOfWeekString = ("Sun")
        }
        
        return dayOfWeekString
    }
    
}
