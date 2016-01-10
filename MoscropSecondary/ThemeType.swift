//
//  ThemeType.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2016-01-07.
//  Copyright (c) 2016 Ivon Liu. All rights reserved.
//

import UIKit
enum ThemeType : String {
    case Light = "Light"
    case Dark = "Dark"
    case Black = "Black"
    case TransparentBlack = "Trans"
    
    var mainColor: UIColor {
        switch self {
        case .Light:
            return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Black:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        case .TransparentBlack:
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        
        }
    }
    var barColor: UIColor {
        switch self {
        case .Light:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 0.0/255.0, green: 137.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .Black:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 0.1)
        case .TransparentBlack:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 0.01)
        }
    }
    var buttonColor: UIColor {
        switch self {
        case .Light:
            return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Black:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            
        case .TransparentBlack:
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
            
        }
    }
}