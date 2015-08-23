//
//  RSSItem.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 8/22/15.
//  Copyright © 2015 Ivon Liu. All rights reserved.
//

import UIKit

class RSSItem {
    
    // MARK: Properties
    var objectId: String
    var date: Int64
    var title: String
    var categories: [String]
    var icon: String
    var bgImage: String?
    
    // MARK: Initialization
    
    init(objectId: String, date: Int64, title: String, categories: [String], icon: String, bgImage: String?) {
        // Initialize stored properties.
        self.objectId = objectId
        self.date = date
        self.title = title
        self.categories = categories
        self.icon = icon
        self.bgImage = bgImage
    }
}