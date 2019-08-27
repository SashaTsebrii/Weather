//
//  UIColor.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/24/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    struct DesignColor {
        struct Background {
            struct Morning {
                static let Up = UIColor(netHex: 0x6DD5ED)
                static let Down = UIColor(netHex: 0x2193B0)
            }
            struct Afternoon {
                static let Up = UIColor(netHex: 0xF9D423)
                static let Down = UIColor(netHex: 0xE65C00)
            }
            struct Evening {
                static let Up = UIColor(netHex: 0x1488CC)
                static let Down = UIColor(netHex: 0x2B32B2)
            }
        }
    }
}
