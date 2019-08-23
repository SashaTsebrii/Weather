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
    
    fileprivate func fetchWeatherDataJSON(latitude: Double,
                                          longitude: Double,
                                          completion: @escaping (Result<WeatherData, Error>) -> ()) {
        
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(Int(latitude))&lon=\(Int(longitude))"
        let appId = "&appid=ef5d4887deb3458a3a2496acdb4f8b5e"
        let urlString = baseUrl + appId
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // successful
            do {
                let courses = try JSONDecoder().decode(WeatherData.self, from: data!)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
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
            
            fetchWeatherDataJSON(latitude: locationCoordinate.latitude,
                                 longitude: locationCoordinate.longitude) { (result) in
                                    switch result {
                                    case .success(let weather):
                                        print(weather)
                                    case .failure(let error):
                                        print("Failed to fetch weather:", error)
                                    }
            }
            
        }
        
    }
    
}
