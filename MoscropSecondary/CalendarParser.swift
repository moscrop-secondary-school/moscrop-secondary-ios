//
//  CalendarParser.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2016-01-15.
//  Copyright (c) 2016 Ivon Liu. All rights reserved.
//

import Foundation
import SwiftyJSON

class CalendarParser {
    
    class func parseJSON(completionHandler: (events: [GCalEvent]) -> ()){
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/moscroppanthers@gmail.com/events?maxResults=1000&orderBy=startTime&singleEvents=true&key=AIzaSyDQgD1es2FQdm4xTA1tU8vFniOglwe4HsE")
        var request = NSURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        var array = [GCalEvent]()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            var json = JSON(data: data!)
            if (error == nil){
                if let items = json["items"] as? JSON {
                    for var index = 0; index < items.count; ++index {
                        var gEvent = self.createEvent(items[index])
                        array.append(gEvent)
                    }
                    completionHandler(events: array)
                }
                
            }
        })
        task.resume()
    }
    
    class func createEvent(item: JSON) -> GCalEvent{
        var title = ""
        var description = ""
        var location = ""
        var startTime:Int64 = -1
        var endTime:Int64 = -1
        if let itemTitle = item["summary"].string {
            title = itemTitle
        }
        if let itemDesc = item["description"].string {
            description = itemDesc
        }
        if let itemLoc = item["location"].string {
            location = itemLoc
        }
        if let itemStart = item["start"]["dateTime"].string{
            startTime = Int64(Utils.parseRCF339Date(itemStart, dateOnly: false).timeIntervalSince1970 * 1000)
        }
        
        if (startTime == -1) {
            if let itemStart = item["start"]["date"].string {
                startTime = Int64(Utils.parseRCF339Date(itemStart, dateOnly: true).timeIntervalSince1970 * 1000)
            }
            
        }
        
        if let itemEnd = item["end"]["dateTime"].string{
            endTime = Int64(Utils.parseRCF339Date(itemEnd, dateOnly: false).timeIntervalSince1970 * 1000)
        }
        
        if (endTime == -1) {
            if let itemEnd = item["end"]["date"].string{
                endTime = Int64(Utils.parseRCF339Date(itemEnd,dateOnly: true).timeIntervalSince1970 * 1000)
            }
            
        }
        
        var gEvent = GCalEvent(title: title, description: description, location: location, startTime: startTime, endTime: endTime)
        
        return gEvent
    }
}