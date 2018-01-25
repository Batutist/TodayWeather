//
//  WeekWeatherCollectionViewCell.swift
//  TodayWeather
//
//  Created by Sergey on 24.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit

class WeekWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTemperatureMax: UILabel!
    @IBOutlet weak var weathertemperatureMin: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
}
