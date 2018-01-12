////
////  APIWeatherManager.swift
////  TodayWeather
////
////  Created by Sergey on 12.01.2018.
////  Copyright © 2018 Sergey. All rights reserved.
////
//
//import Foundation
//
//extension Dictionary {
//    mutating func merge(other:Dictionary) {
//        for (key,value) in other {
//            self.updateValue(value, forKey:key)
//        }
//    }
//}
//
//final class APIWeatherManager: APIManager {
//    
//    enum ForecastType: FinalURLPoint {
//        
//        var defaultURL: URL {
//            let url = URL(string: "http://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22")
//            return url!
//        }
//        
//        case TodayWeather(apiKey: String, cityName: String)
//        
//        var baseURL: URL {
//            return URL(string: "http://api.openweathermap.org")!
//        }
//        
//        var path: String {
//            switch self {
//            case .TodayWeather(let apiKey, let cityName):
//                return "/data/2.5/weather?appid=\(apiKey)&q=\(cityName)&units=metric"
//            }
//        }
//
//        var request: URLRequest {
//            guard let url = URL(string: path, relativeTo: baseURL) else { return URLRequest(url: defaultURL) }
//            return URLRequest(url: url)
//        }
//        
//    }
//    
//    
//    let sessionConfiguration: URLSessionConfiguration
//    lazy var session: URLSession = {
//        return URLSession(configuration: sessionConfiguration)
//    }()
//    
//    let apiKey: String
//    
//    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
//        self.sessionConfiguration = sessionConfiguration
//        self.apiKey = apiKey
//    }
//    
//    convenience init(apiKey: String) {
//        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
//    }
//    
//    let cityName = "Taganrog"
//    func fetchCurrentWeatherWith(cityName: String, completitionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
//        
//        let request = ForecastType.TodayWeather(apiKey: self.apiKey, cityName: self.cityName).request
//        fetch(request: request, parse: { (json) -> CurrentWeather? in
//
//            let dictionary = json["main"] as! [String: AnyObject]
//            print(dictionary)
//            return CurrentWeather(JSON: dictionary)
//
//        }, completitionHandler: completitionHandler)
//        
//    }
//}
//
//
//
//
//
//
