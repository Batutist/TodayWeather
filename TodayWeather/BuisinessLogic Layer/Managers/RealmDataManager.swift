//
//  RealmDataManager.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataManager {
    
    func getCurrentWeatherFromRealm(cityName: String) -> FetchedResults<CurrentWeather> {
        
        let container = Container(realm: realm)
        let currentWeather = container.values(CurrentWeather.self, matching: .cityName(cityName))
        
        return currentWeather
    }
    
    func getSearchCityWeatherFromRealm(searchCityName: String) -> FetchedResults<SearchCityWeather> {
        
        let container = Container(realm: realm)
        let searchCityWeather = container.values(SearchCityWeather.self, matching: .cityName(searchCityName))
        
        return searchCityWeather
    }
    
    func getWeekweatherFromRealm(for city: String) -> Results<WeekWeatherClass> {
        do {
            let realm = try Realm()
            let weekWeather = realm.objects(WeekWeatherClass.self).filter("cityName == %@", city)
            
            print("Here is weekWeather \(weekWeather)")
            return weekWeather
        } catch let error as NSError {
            fatalError("Error opening realm: \(error)")
        }
    }
    
}
