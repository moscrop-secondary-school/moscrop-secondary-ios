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
    var startTime: Int64
    var endTime: Int64
    
    init (title: String, description: String, location: String, startTime: Int64, endTime: Int64) {
        self.title = title
        self.description = description
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
    }
}