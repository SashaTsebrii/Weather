//
//  UVIndexData.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/25/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import Foundation

// MARK: - UVIndex
struct UVIndex: Codable {
    let lat: Double?
    let lon: Double?
    let dateIso: Date?
    let date: Int?
    let value: Double?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
        case dateIso = "date_iso"
        case date = "date"
        case value = "value"
    }
}
