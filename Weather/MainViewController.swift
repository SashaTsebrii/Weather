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
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var firstTime = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        var colorTop =  UIColor.white.cgColor
        var colorBottom = UIColor.white.cgColor
        
        if hour >= 0 && hour < 4 {
            // evening
            colorTop = UIColor.DesignColor.Background.Evening.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Evening.Down.cgColor
        } else if hour >= 4 && hour < 10 {
            // morning
            colorTop = UIColor.DesignColor.Background.Morning.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Morning.Down.cgColor
        } else if hour >= 10 && hour < 18 {
            // afternoon
            colorTop = UIColor.DesignColor.Background.Afternoon.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Afternoon.Down.cgColor
        } else if hour >= 18 {
            // evening
            colorTop = UIColor.DesignColor.Background.Evening.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Evening.Down.cgColor
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
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
    
    private func secondsToTime(_ seconds: Int) -> String {
        // Convert integer to date.
        let sunsetTimeInterval = Double(seconds)
        let sunsetDate = Date(timeIntervalSince1970: sunsetTimeInterval)
        
        // Format date to hours and minutes.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated.
        dateFormatter.dateFormat = "HH:mm" // Output formated.
        return dateFormatter.string(from: sunsetDate)
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationCoordinate.latitude) \(locationCoordinate.longitude)")
        
        if firstTime == false {
            firstTime = true
            
            let baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(Int(locationCoordinate.latitude))&lon=\(Int(locationCoordinate.longitude))"
            let appId = "&appid=73b47c417853124ff96170ad0a90aa60"
            let urlString = baseUrl + appId
            guard let url = URL(string: urlString) else { return }
            
            let task = URLSession.shared.weatherDataTask(with: url) { weatherData, response, error in
                if let weatherData = weatherData {
                    print(weatherData)
                    
                    if let temp = weatherData.main?.temp {
                        DispatchQueue.main.async {
                            let correctTemp = temp - 273.15
                            self.tempLabel.text = "\(Int(correctTemp)) ℃"
                        }
                    }
                    
                    if let country = weatherData.sys?.country, let city = weatherData.name {
                        DispatchQueue.main.async {
                            self.locationLabel.text = "\(city), \(country)"
                        }
                    }
                    
                    if let sunrise = weatherData.sys?.sunrise, let sunset = weatherData.sys?.sunset {
                        DispatchQueue.main.async {
                            self.sunriseLabel.text = "\(self.secondsToTime(sunrise))"
                            self.sunsetLabel.text = "\(self.secondsToTime(sunset))"
                        }
                    }
                    
                    if let weather = weatherData.weather {
                        if let correctWeathe = weather.first {
                            if let icon = correctWeathe.icon {
                                DispatchQueue.main.async {
                                    let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
                                    self.weatherImageView.downloaded(from: urlString)
                                }
                            }
                            
                            if let description = correctWeathe.weatherDescription {
                                DispatchQueue.main.async {
                                    self.descriptionLabel.text = description.firstCapitalized
                                }
                            }
                        }
                    }
                    
                }
            }
            task.resume()
            
        }
        
    }
    
}
