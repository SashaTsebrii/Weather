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
    
    // MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var uvIndexTextView: UITextView!
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var firstTime = false
    let historySegueIdentifier = Constants.SegueIdentifier.showHistoryFromMain
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pressure: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        // TODO:
//        let hour = 22
        
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == historySegueIdentifier {
//            let destinationViewController = segue.destination as! HistoryViewController
//            destinationViewController.venue = venue
        }
    }
    
    // MARK: - Actions
    
    @IBAction func moodButtonTapped(_ sender: UIButton) {
        
        var moodImage = ""
        if sender.tag == 1 {
            moodImage = "happy"
        } else if  sender.tag == 2 {
            moodImage = "neutral"
        } else if sender.tag == 3 {
            moodImage = "sad"
        }
        
        let mood = MoodData(context: context)
        mood.moodImage = moodImage
        mood.locationString = locationLabel.text
        mood.weatherImage = weatherImageView.accessibilityIdentifier!
        mood.temperatureString = tempLabel.text
        mood.uvIndexString = uvIndexLabel.text
        mood.pressureString = pressure
        mood.date = Date()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        performSegue(withIdentifier: historySegueIdentifier, sender: nil)
    }
    
    @IBAction func listBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: historySegueIdentifier, sender: nil)
    }
    
    // MARK: - Functions
    
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
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationCoordinate.latitude) \(locationCoordinate.longitude)")
        
        if firstTime == false {
            firstTime = true
            
            // Weather
            
            let appId = "appid=73b47c417853124ff96170ad0a90aa60"
            let coordinateUrl = "lat=\(Int(locationCoordinate.latitude))&lon=\(Int(locationCoordinate.longitude))"
            
            let weatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
            let weatherUrlString = weatherBaseUrl + "?" + coordinateUrl + "&" + appId
            guard let weatherUrl = URL(string: weatherUrlString) else { return }
            
            let weatherTask = URLSession.shared.weatherDataTask(with: weatherUrl) { weatherData, response, error in
                if let weatherData = weatherData {
                    print(weatherData)
                    
                    if let pressure = weatherData.main?.pressure {
                        self.pressure = "\(pressure)"
                    }
                    
                    if let temp = weatherData.main?.temp {
                        DispatchQueue.main.async {
                            let correctTemp = temp - 273.15
                            // TODO:
//                            let correctTemp = 18.5
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
                                    if icon == "01d" || icon == "01n" {
                                        self.weatherImageView.image = UIImage(named: "sun")
                                        self.weatherImageView.image?.accessibilityIdentifier = "sun"
                                    } else if icon == "02d" || icon == "02n" {
                                        self.weatherImageView.image = UIImage(named: "partly_cloudy")
                                        self.weatherImageView.image?.accessibilityIdentifier = "partly_cloudy"
                                    } else if icon == "03d" || icon == "03n" {
                                        self.weatherImageView.image = UIImage(named: "cloud")
                                        self.weatherImageView.image?.accessibilityIdentifier = "cloud"
                                    } else if icon == "04d" || icon == "04n" {
                                        self.weatherImageView.image = UIImage(named: "cloud")
                                        self.weatherImageView.image?.accessibilityIdentifier = "cloud"
                                    } else if icon == "09d" || icon == "09n" {
                                        self.weatherImageView.image = UIImage(named: "downpour")
                                        self.weatherImageView.image?.accessibilityIdentifier = "downpour"
                                    } else if icon == "10d" || icon == "10n" {
                                        self.weatherImageView.image = UIImage(named: "rain")
                                        self.weatherImageView.image?.accessibilityIdentifier = "rain"
                                    } else if icon == "11d" || icon == "11n" {
                                        self.weatherImageView.image = UIImage(named: "cloud_lighting")
                                        self.weatherImageView.image?.accessibilityIdentifier = "cloud_lighting"
                                    } else if icon == "13d" || icon == "13n" {
                                        self.weatherImageView.image = UIImage(named: "snow")
                                        self.weatherImageView.image?.accessibilityIdentifier = "snow"
                                    } else if icon == "50d" || icon == "50n" {
                                        self.weatherImageView.image = UIImage(named: "wind")
                                        self.weatherImageView.image?.accessibilityIdentifier = "wind"
                                    }
//                                    let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
//                                    self.weatherImageView.downloaded(from: urlString)
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
            weatherTask.resume()
            
            
            // UV Index
            
            let indexBaseUrl = "http://api.openweathermap.org/data/2.5/uvi"
            
            let indexUrlString = indexBaseUrl + "?" + appId + "&" + coordinateUrl
            guard let indexUrl = URL(string: indexUrlString) else { return }
            
            let indexTask = URLSession.shared.uvIndexTask(with: indexUrl) { uvIndex, response, error in
                if let uvIndex = uvIndex {
                    if let value = uvIndex.value {
                        // TODO:
//                        var value: Double?
//                        value = 4.3
//                        if let value = value {
                        DispatchQueue.main.async {
                            self.uvIndexLabel.text = "\(value)"
                            
                            if value < 3  {
                                self.uvIndexTextView.text = """
                                A UV index reading of 0 to 2.9 means low danger from the Sun's UV rays for the average person.
                                Wear sunglasses on bright days. If you burn easily, cover up and use broad spectrum SPF 30+ sunscreen. Bright surfaces, such as sand, water, and snow, will increase UV exposure.
                                """
                            } else if value >= 3 && value < 6 {
                                self.uvIndexTextView.text = """
                                A UV index reading of 3 to 5.9 means moderate risk of harm from unprotected Sun exposure.
                                Stay in shade near midday when the Sun is strongest. If outdoors, wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.
                                """
                            } else if value >= 6 && value < 8 {
                                self.uvIndexTextView.text = """
                                A UV index reading of 6 to 7.9 means high risk of harm from unprotected Sun exposure. Protection against skin and eye damage is needed.
                                Reduce time in the Sun between 10 a.m. and 4 p.m. If outdoors, seek shade and wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.
                                """
                            } else if value >= 8 && value < 11 {
                                self.uvIndexTextView.text = """
                                A UV index reading of 8 to 10.9 means very high risk of harm from unprotected Sun exposure. Take extra precautions because unprotected skin and eyes will be damaged and can burn quickly.
                                Minimize Sun exposure between 10 a.m. and 4 p.m. If outdoors, seek shade and wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.
                                """
                            } else if value >= 11 {
                                self.uvIndexTextView.text = """
                                A UV index reading of 11 or more means extreme risk of harm from unprotected Sun exposure. Take all precautions because unprotected skin and eyes can burn in minutes.
                                Try to avoid Sun exposure between 10 a.m. and 4 p.m. If outdoors, seek shade and wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.
                                """
                            }
                        }
                    }
                }
            }
            indexTask.resume()
            
        }
        
    }
    
}
