//
//  WeekWeatherViewController.swift
//  TodayWeather
//
//  Created by Sergey on 24.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit

class WeekWeatherViewController: UIViewController{
    let realmManager = RealmDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This view is load")
        DataManagerSingleton.shared.getWeekWeather(city: "Oslo", units: units)
        
        let results = realmManager.getWeekweatherFromRealm()
        let filterResults = results.first?.weekWeatherDetails.filter("date contains '12:00:00'")
        print("results: \(filterResults)")
    }
    
    

}

extension WeekWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeekWeatherCollectionViewCell
        
        return cell
    }
    
}
