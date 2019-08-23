//
//  WeatherData.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/23/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    
    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
        case dt = "dt"
        case sys = "sys"
        case timezone = "timezone"
        case id = "id"
        case name = "name"
        case cod = "cod"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
    
    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Int?
    let lat: Int?
    
    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double?
    let pressure: Int?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    let seaLevel: Int?
    let grndLevel: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
}
