//
//  WeekWeather.swift
//  TodayWeather
//
//  Created by Sergey on 24.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation

struct WeekWeather {
    
    var cityName = ""
    var country = ""
    
    let weekWeatherDetails = WeekWeatherDetails()
    
}

//extension WeekWeather: Persistable {
//    
//    public init(mangedObject: WeekWeatherClass) {
//        cityName = mangedObject.cityName
//        country = mangedObject.country
//        weekWeatherDetails = mangedObject.weekWeatherDetails.flatmap(WeekWeatherDetails.init(mangedObject:))
//    }
//    public func toManagedObject() -> WeekWeatherClass {
//        let weekWeather = WeekWeatherClass()
//        
//        weekWeather.cityName = cityName
//        weekWeather.country = country
//        weekWeather.weekWeatherDetails = weekWeatherDetails.managedObject()
//        
//        return weekWeather
//    }
//    
//}


