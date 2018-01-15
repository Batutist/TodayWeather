//
//  CurrentWeatherClass.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class CurrentWeatherClass: Object {
    
    
    
//    static func getObject(from realm: Realm) -> CurrentWeatherClass? {
//        //        let realm = try! Realm()
//        let results = realm.objects(CurrentWeatherClass.self)
//        guard let currentWeather = results.first else { return nil }
//        return currentWeather
//    }
//    
//    static func createObjectInRealm(_ realm : Realm) -> CurrentWeatherClass? {
////        guard let messageMO = NSEntityDescription.insertNewObject(forEntityName: MessageMO.entityName, into: context) as? MessageMO else {return nil}
//        let manager = DataManager()
//        manager.getWeatherData(city: "Taganrog")
//        
//        guard let currentWeather = getObject(from: realm) else { return nil }
//        
//        return currentWeather
//    }
    
    @objc dynamic var cityName: String = ""
    @objc dynamic var cityCountry: String = ""
    @objc dynamic var cityTemperature: Int = 0
    @objc dynamic var cityWindSpeed: Double = 0.0
    @objc dynamic var cityPressure: Double = 0.0
    @objc dynamic var cityHumidity: Int = 0
    @objc dynamic var cityTemperatureMin: Int = 0
    @objc dynamic var cityTemperatureMax: Int = 0
    @objc dynamic var cityWeatherDescription: String = ""
    @objc dynamic var cityWeatherIcon: String = ""
    
    override static func primaryKey() -> String {
        return "cityName"
    }
    
}


//extension CurrentWeatherClass: ManagedObjectProtocol {
//    func toEntity() -> CurrentWeather? {
//        
//        let currentWeather = CurrentWeather(cityName: cityName,
//                                            cityCountry: cityCountry,
//                                            cityTemperature: cityTemperature,
//                                            cityWindSpeed: cityWindSpeed,
//                                            cityPressure: cityPressure,
//                                            cityHumidity: cityHumidity,
//                                            cityTemperatureMin: cityTemperatureMin,
//                                            cityTemperatureMax: cityTemperatureMax,
//                                            cityWeatherDescription: cityWeatherDescription,
//                                            cityWeatherIcon: cityWeatherIcon)
//        
//        return currentWeather
//    }
//}




