//
//  GCalEvent.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2016-01-16.
//  Copyright (c) 2016 Ivon Liu. All rights reserved.
//

import Foundation
class GCalEvent {
    var title: String
    var description: String
    var location: String
    var startDate: NSDate
    var endDate: NSDate
    
    init (title: String, description: String, location: String, startDate: NSDate, endDate: NSDate) {
        self.title = title
        self.description = description
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
    }
}