//
//  WeekWeatherClass.swift
//  TodayWeather
//
//  Created by Sergey on 24.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class WeekWeatherClass: Object {
    
    @objc dynamic var cityName = ""
    @objc dynamic var country = ""
    
    var weekWeatherDetails: WeekWeatherDetails?
    
    override static func primaryKey() -> String {
        return "cityName"
    }
    
}
