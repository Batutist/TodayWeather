//
//  ViewController.swift
//  TodayWeather
//
//  Created by Sergey on 16.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit

private enum Segments: Int {
    case Metric = 0
    case Imperial = 1
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var chooseUnits: UISegmentedControl!
    @IBOutlet weak var temperatireInfoLabel: UILabel!
    @IBOutlet weak var windSpeedInfoLabel: UILabel!
//    var units: String?
    
    let temperatureInCelsius = "Temperature will be displaying in ˚C"
    let temperatureInFahrenheit = "Temperature will be displaying in ˚F"
    let windSpeedInMeterPerSecond = "Wind speed will be dispalying in m/s"
    let windSpeedInMilesPerHour = "Wind speed will be dispalying in MPH"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if units == "metric" {
            print(Segments.Metric.rawValue)
            chooseUnits.selectedSegmentIndex = Segments.Metric.rawValue
            temperatireInfoLabel.text = temperatureInCelsius
            windSpeedInfoLabel.text = windSpeedInMeterPerSecond
        } else {
            chooseUnits.selectedSegmentIndex = Segments.Imperial.rawValue
            temperatireInfoLabel.text = temperatureInFahrenheit
            windSpeedInfoLabel.text = windSpeedInMilesPerHour
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseUnits(_ sender: UISegmentedControl) {
        let selectedSegment = Segments(rawValue: sender.selectedSegmentIndex)!
        
        switch selectedSegment {
        case .Metric:
            userDefaults.set("metric", forKey: "units")
            
            temperatireInfoLabel.text = temperatureInCelsius
            windSpeedInfoLabel.text = windSpeedInMeterPerSecond
            units = "metric"
            print("Metric")
        case .Imperial:
            userDefaults.set("imperial", forKey: "units")
            
            temperatireInfoLabel.text = temperatureInFahrenheit
            windSpeedInfoLabel.text = windSpeedInMilesPerHour
            units = "imperial"
            print("Imperial")
        }
    }
    
//    @IBAction func saveChoosenUnits(_ sender: UIButton) {
//        
//        performSegue(withIdentifier: "unwindSegueWithData", sender: sender)
//        
//    }
}
