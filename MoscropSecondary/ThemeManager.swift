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
        UINavigationBar.appearance().barStyle = theme.barStyle
        
        UITabBar.appearance().barStyle = theme.barStyle
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.imageWithRenderingMode(.AlwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImageWithCapInsets(
            UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    }
}