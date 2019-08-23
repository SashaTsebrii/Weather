//
//  MainViewController.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/23/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var firstTime = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    fileprivate func fetchWeatherJSON(latitude: Double,
                                      longitude: Double,
                                      completion: @escaping (WeatherData?, Error?) -> ()) {
        
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(Int(latitude))&lon=\(Int(longitude))"
        let appId = "&appid=ef5d4887deb3458a3a2496acdb4f8b5e"
        let urlString = baseUrl + appId
        guard let url = URL(string: urlString) else {
            print("Failed url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                // unsuccessful
                completion(nil, error)
                return
            }
            
            // successful
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: data!)
                completion(weather, nil)
            } catch let jsonError{
                completion(nil, jsonError)
            }
            
        }.resume()
        
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationCoordinate.latitude) \(locationCoordinate.longitude)")
        
        if firstTime == false {
            firstTime = true
            
            fetchWeatherJSON(latitude: locationCoordinate.latitude,
                             longitude: locationCoordinate.longitude) { (weather, error) in
                if let error = error {
                    print("Failed to fetch weather:", error)
                    return
                }
                
                if let weather = weather {
                    print(weather)
                }
                
            }
        }
        
    }
    
}
