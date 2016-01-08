//
//  ThemeManager.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2016-01-08.
//  Copyright (c) 2016 Ivon Liu. All rights reserved.
//

import UIKit
struct ThemeManager {
    static func currentTheme() -> ThemeType {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey("Theme") {
            return ThemeType(rawValue: storedTheme as! String)!
        } else {
            return ThemeType.Light
        }
    }
    static func applyTheme(theme: ThemeType) {
        
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
    }
}