//
//  StringProtocol.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/24/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
