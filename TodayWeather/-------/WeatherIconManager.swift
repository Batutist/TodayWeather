//
//  WeatherIconManager.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import UIKit

enum WeatherIconManager: String {
    
    case ClearSkyDay = "01d"
    case ClearSkyNight = "01n"
    case FewCloudsDay = "02d"
    case FewCloudsNight = "02n"
    case ScatteredCloudsDay = "03d"
    case ScatteredCloudsNight = "03n"
    case BrokenCloudsDay = "04d"
    case BrokenCloudsNight = "04n"
    case ShowerRainDay = "09d"
    case ShowerRainNight = "09n"
    case RainDay = "10d"
    case RainNight = "10n"
    case ThunderstormDay = "11d"
    case ThunderstormNight = "11n"
    case SnowDay = "13d"
    case SnowNight = "13n"
    case MistDay = "50d"
    case MistNight = "50n"
    case UnpredictedIcon = "cloudly"
    
    init(rawValue: String) {
        switch rawValue {
        case "01d": self = .ClearSkyDay
        case "01n": self = .ClearSkyNight
        case "02d": self = .FewCloudsDay
        case "02n": self = .FewCloudsNight
        case "03d": self = .ScatteredCloudsDay
        case "03n": self = .ScatteredCloudsNight
        case "04d": self = .BrokenCloudsDay
        case "04n": self = .BrokenCloudsNight
        case "09d": self = .ShowerRainDay
        case "09n": self = .ShowerRainNight
        case "10d": self = .RainDay
        case "10n": self = .RainNight
        case "11d": self = .ThunderstormDay
        case "11n": self = .ThunderstormNight
        case "13d": self = .SnowDay
        case "13n": self = .SnowNight
        case "50d": self = .MistDay
        case "50n": self = .MistNight
        default: self = .UnpredictedIcon
        }
    }
}

extension WeatherIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
