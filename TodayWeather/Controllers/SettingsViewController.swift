//
//  ViewController.swift
//  TodayWeather
//
//  Created by Sergey on 16.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var chooseUnits: UISegmentedControl!
    @IBOutlet weak var temperatireInfoLabel: UILabel!
    @IBOutlet weak var windSpeedInfoLabel: UILabel!
    var units: String?
    
    let temperatureInCelsius = "Temperature will be displaying in ˚C"
    let temperatureInFahrenheit = "Temperature will be displaying in ˚F"
    let windSpeedInMeterPerSecond = "Wind speed will be dispalying in m/s"
    let windSpeedInMilesPerHour = "Wind speed will be dispalying in MPH"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if units == "metric" {
            chooseUnits.selectedSegmentIndex = 0
            temperatireInfoLabel.text = temperatureInCelsius
            windSpeedInfoLabel.text = windSpeedInMeterPerSecond
        } else {
            chooseUnits.selectedSegmentIndex = 1
            temperatireInfoLabel.text = temperatureInFahrenheit
            windSpeedInfoLabel.text = windSpeedInMilesPerHour
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chooseUnits.selectedSegmentIndex)
    }
    
    @IBAction func chooseUnits(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            userDefaults.set("metric", forKey: "units")
            
            temperatireInfoLabel.text = temperatureInCelsius
            windSpeedInfoLabel.text = windSpeedInMeterPerSecond
            units = "metric"
            print(chooseUnits.selectedSegmentIndex)
        case 1:
            userDefaults.set("imperial", forKey: "units")
            
            temperatireInfoLabel.text = temperatureInFahrenheit
            windSpeedInfoLabel.text = windSpeedInMilesPerHour
            units = "imperial"
            print(chooseUnits.selectedSegmentIndex)
        default:
            break
        }
    }
    
    @IBAction func saveChoosenUnits(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindSegueWithData", sender: sender)
        
    }
}
