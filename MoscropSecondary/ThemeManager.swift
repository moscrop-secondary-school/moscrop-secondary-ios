//
//  ThemeManager.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2016-01-08.
//  Copyright (c) 2016 Ivon Liu. All rights reserved.
//

import UIKit
struct ThemeManager {
    // Retrieves current theme from NSUserDefaults
    static func currentTheme() -> ThemeType {
        if let storedTheme: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("Theme") {
            return ThemeType(rawValue: storedTheme as! String)!
        } else {
            return ThemeType.Light
        }
    }
    
    // applies theme according to theme type specified
    static func applyTheme(theme: ThemeType) {
        
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: theme.mainColor]
        UINavigationBar.appearance().titleTextAttributes = titleDict as! [String : AnyObject]
        
        UINavigationBar.appearance().barTintColor = theme.barColor
        UITabBar.appearance().barTintColor = theme.barColor
        
        
    }
}