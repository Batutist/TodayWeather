//
//  WeekWeatherViewController.swift
//  TodayWeather
//
//  Created by Sergey on 24.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit
import RealmSwift

class WeekWeatherViewController: UIViewController {
    // create notification Token to watch for changes
    // токен для отслеживания изменений
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    lazy var manager = DataManagerSingleton.shared
    let realmManager = RealmDataManager()
    
    private var weekWeatherModel = WeekWeatherClass()
    
    let city = "Las Vegas"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This view is load")
        manager.getWeekWeather(city: city, units: units)
        updateUI()
        
    }
    
    func checkOutDates(timeIntervalSince1970: Double) -> Bool {
        let dateFormatter = DateFormatter()
        // преобразуем формат даты дня в строку
        var weekWeatherNoonDateString: String {
            let date = Date(timeIntervalSince1970: timeIntervalSince1970)
            dateFormatter.dateFormat = "dd.MM"
            return dateFormatter.string(from: date as Date)
        }
        print(weekWeatherNoonDateString)
        // преобразуем дату на момент запроса в строку
        var todayString: String {
            let today = NSDate()
            dateFormatter.dateFormat = "dd.MM"
            return dateFormatter.string(from: today as Date)
        }
        return weekWeatherNoonDateString == todayString ? true : false
    }
    
    
    func getWeatherFromDB() {
        guard let results = realmManager.getWeekweatherFromRealm(for: city).first else { return }
        let weekWeatherNoon = results.weekWeatherDetails.filter("date contains '12:00:00'")
        print("weekweathernoon: \(weekWeatherNoon)")
        guard let forecastedTime = weekWeatherNoon.first?.forecastedTime else { return }
        
        weekWeatherModel.cityName = results.cityName
        weekWeatherModel.country = results.country
        
        if checkOutDates(timeIntervalSince1970: forecastedTime) {
            for value in weekWeatherNoon {
                let tmp = WeekWeatherDetailsClass()

                tmp.date = value.date
                tmp.forecastedTime = value.forecastedTime
                tmp.humidity = value.humidity
                tmp.pressure = value.pressure
                tmp.temperatureMax = value.temperatureMax
                tmp.temperatureMin = value.temperatureMin
                tmp.weatherDescription = value.weatherDescription
                tmp.weatherIcon = value.weatherIcon
                tmp.windDegrees = value.windDegrees
                tmp.windSpeed = value.windSpeed

                weekWeatherModel.weekWeatherDetails.append(tmp)
            }
        } else {
            guard let firstDayweather = results.weekWeatherDetails.first else { return }
            
            let tmp = WeekWeatherDetailsClass()
            
            tmp.date = firstDayweather.date
            tmp.forecastedTime = firstDayweather.forecastedTime
            tmp.humidity = firstDayweather.humidity
            tmp.pressure = firstDayweather.pressure
            tmp.temperatureMax = firstDayweather.temperatureMax
            tmp.temperatureMin = firstDayweather.temperatureMin
            tmp.weatherDescription = firstDayweather.weatherDescription
            tmp.weatherIcon = firstDayweather.weatherIcon
            tmp.windDegrees = firstDayweather.windDegrees
            tmp.windSpeed = firstDayweather.windSpeed
            
            weekWeatherModel.weekWeatherDetails.append(tmp)
            for value in weekWeatherNoon {
                let tmp = WeekWeatherDetailsClass()
                
                tmp.date = value.date
                tmp.forecastedTime = value.forecastedTime
                tmp.humidity = value.humidity
                tmp.pressure = value.pressure
                tmp.temperatureMax = value.temperatureMax
                tmp.temperatureMin = value.temperatureMin
                tmp.weatherDescription = value.weatherDescription
                tmp.weatherIcon = value.weatherIcon
                tmp.windDegrees = value.windDegrees
                tmp.windSpeed = value.windSpeed
                
                weekWeatherModel.weekWeatherDetails.append(tmp)
            }
        }
    }
    
    func changeLabelsAndImagesIn(cell: WeekWeatherCollectionViewCell, indexPath: IndexPath) {
        print(weekWeatherModel)
        
        cityNameLabel.text = weekWeatherModel.cityName
        
        cell.dateLabel.text = weekWeatherModel.weekWeatherDetails[indexPath.row].dateString
        cell.dayOfTheWeekLabel.text = weekWeatherModel.weekWeatherDetails[indexPath.row].dayOfWeek
        cell.weatherDescription.text = weekWeatherModel.weekWeatherDetails[indexPath.row].weatherDescription
        cell.weatherIcon.image = UIImage(named: weekWeatherModel.weekWeatherDetails[indexPath.row].weatherIcon)
        cell.weatherTemperatureMax.text = weekWeatherModel.weekWeatherDetails[indexPath.row].temperatureMaxString
        cell.weathertemperatureMin.text = weekWeatherModel.weekWeatherDetails[indexPath.row].temperatureMinString
        cell.windDirectionLabel.text = String(weekWeatherModel.weekWeatherDetails[indexPath.row].windDegreesString)
        cell.windSpeedLabel.text = weekWeatherModel.weekWeatherDetails[indexPath.row].windSpeedString
    }
    
    func updateUI() {
        let results = realm.objects(WeekWeatherClass.self)
        
        // Observe Results Notifications
        notificationToken = results.observe {[weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                print("new")
            case .update(_,_,_,_):
                self?.getWeatherFromDB()
                collectionView.reloadData()
                print("update")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}


extension WeekWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekWeatherModel.weekWeatherDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeekWeatherCollectionViewCell
        
        changeLabelsAndImagesIn(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
}
