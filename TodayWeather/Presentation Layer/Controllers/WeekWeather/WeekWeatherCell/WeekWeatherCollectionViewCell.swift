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
    @IBOutlet weak var dayWeatherIcon: UIImageView!
    @IBOutlet weak var dayWeatherDescription: UILabel!
    @IBOutlet weak var dayWeatherTemperature: UILabel!
    @IBOutlet weak var nightWeathertemperature: UILabel!
    @IBOutlet weak var nightWeathrerIcon: UIImageView!
    @IBOutlet weak var nightWeatherDescription: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
}
