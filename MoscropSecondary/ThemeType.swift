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
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Black:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        
        case .TransparentBlack:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        }
    }
    var barStyle: UIBarStyle {
        switch self {
        case .Light:
            return .Default
        case .Dark, .TransparentBlack, .Black:
            return .Black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Light:
            return UIColor(white: 0.9, alpha: 1.0)
        case .Dark, .Black, .TransparentBlack:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Light:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark, .Black, .TransparentBlack:
            return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        }
    }
}