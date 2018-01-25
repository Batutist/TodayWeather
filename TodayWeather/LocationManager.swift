//
//  LocationManager.swift
//  TodayWeather
//
//  Created by Sergey on 25.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location : CLLocation)
}

/// Notification on update of location. UserInfo contains CLLocation for key "location"
let kLocationDidChangeNotification = "LocationDidChangeNotification"

var currentCityName: String?
var currentCountry: String?

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let SharedManager = UserLocationManager()
    fileprivate var LocationManager = CLLocationManager()
    var delegate : LocationUpdateProtocol!
    
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    
    var currentLocation : CLLocation?
    

    lazy var manager = DataManagerSingleton.shared

    
    private override init () {
        super.init()
//        locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
//        locationManager.requestAlwaysAuthorization()
//        self.locationManager.startUpdatingLocation()
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        let authStatus = CLLocationManager.authorizationStatus()
        
        guard authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                    "go to Settings → GeoExample → Location and select the \"While Using " +
                    "the App\" setting.")
            case .notDetermined:
                LocationManager.requestWhenInUseAuthorization()
                LocationManager.requestAlwaysAuthorization()
                LocationManager.startUpdatingLocation()
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        LocationManager.startUpdatingLocation()
    }
    
    // This method is called if:
    // - the location manager is updating, and
    // - it was able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the last user location
        let lastLocation: CLLocation = locations.last!
        
        // if it location is nil or it has been moved
        if currentLocation == nil || currentLocation!.horizontalAccuracy > lastLocation.horizontalAccuracy {
            
            currentLocation = lastLocation
            print("lat is1:\(currentLocation?.coordinate.latitude) lon is1:\(currentLocation?.coordinate.longitude)")
            
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: {[weak self] (placemarks, error) in
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self?.placemark = placemark.last
                }
                // Get city and county name from coordinates
                self?.parsePlacemarks()
            })
        }
    }
    
    // Get city and county name from coordinates
    func parsePlacemarks() {
        // Check if location manager is not nil
        if let _ = currentLocation {
            // Unwrap the placemark
            if let placemark = placemark {
                // Unwrap the locality
                if let cityName = placemark.locality, !cityName.isEmpty, let countryShortName = placemark.isoCountryCode, !countryShortName.isEmpty {
                    // assign city name to our iVar
                    currentCityName = cityName.folding(options: .diacriticInsensitive, locale: .current)
                    currentCountry = countryShortName
                    guard currentCityName != nil, currentCountry != nil else { return }
                    let cityAndCountryName = currentCityName! + ", " + currentCountry!
                    // Get weather data by new location
                    manager.getWeatherData(city: cityAndCountryName, units: units)
                    manager.getWeekWeather(city: cityName, units: units)
                }
                print("current location city is: \(currentCityName!) & country: \(currentCountry!)")
            }
        } else {
            // add some more check's if for some reason location manager is nil
        }
//        // Stop updating location
//        LocationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation = newLocation
        let userInfo : NSDictionary = ["location" : currentLocation!]
        
        DispatchQueue.main.async() { () -> Void in
            self.delegate.locationDidUpdateToLocation(location: self.currentLocation!)
            NotificationCenter.default.post(name: NSNotification.Name(kLocationDidChangeNotification), object: self, userInfo: userInfo as [NSObject: AnyObject])
        }
    }
}
