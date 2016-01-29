//
//  CalendarParser.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2016-01-15.
//  Copyright (c) 2016 Ivon Liu. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreData

class CalendarParser {
    
    class func parseJSON(completionHandler: (events: [GCalEvent]) -> ()){
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/moscroppanthers@gmail.com/events?maxResults=1000&orderBy=startTime&singleEvents=true&timeMin=2015-09-01T00:00:00.000Z&key=AIzaSyDQgD1es2FQdm4xTA1tU8vFniOglwe4HsE")
        var request = NSURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        var array = [GCalEvent]()
        var events = [NSManagedObject]()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            var json = JSON(data: data!)
            if (error == nil){
                if let items = json["items"] as? JSON {
                    for var index = 0; index < items.count; ++index {
                        var gEvent = self.createEvent(items[index])
                        var title = gEvent.title
                        var description = gEvent.description
                        var location = gEvent.location
                        var startDate = gEvent.startDate
                        var endDate = gEvent.endDate
                        if (Utils.isWithinOneDay(gEvent.startDate, endDate: gEvent.endDate)){
//                            array.append(gEvent)
                            
                            self.saveEvent(title, desc: description, location: location, startDate: startDate, endDate: endDate)
                            
                        } else {
                            //append more gEvent because it is a multiple days event
                            
                            while !Utils.sameDay(startDate, endDate: endDate){
                                var newGEvent = GCalEvent(title: title, description: description, location: location, startDate: startDate, endDate: endDate)
//                                array.append(newGEvent)
                                self.saveEvent(gEvent.title, desc: gEvent.description, location: gEvent.location, startDate: gEvent.startDate, endDate: gEvent.endDate)
                                startDate = Utils.addDay(startDate, amount: 1)
                            }
                            
                        }
                        
                    }
//                    array.sort({ (event1: GCalEvent, event2: GCalEvent) -> Bool in
//                        if (Utils.sameDay(event1.startDate, endDate: event2.startDate)){
//                            return event1.title < event2.title
//                        } else {
//                            return Utils.isLessDate(event1.startDate, date2: event2.startDate)
//                        }
//                    })
//                    completionHandler(events: array)
                }
                
            }
        })
        task.resume()
    }
    
    class func saveEvent(name: String, desc: String, location: String, startDate: NSDate, endDate: NSDate) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("CalendarEvent",
            inManagedObjectContext:managedContext!)
        
        let event = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        event.setValue(name, forKey: "title")
        event.setValue(desc, forKey: "desc")
        event.setValue(location, forKey: "location")
        event.setValue(startDate, forKey: "startDate")
        event.setValue(endDate, forKey: "endDate")
        
        //4
        
        var error: NSError?
        if !managedContext!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func createEvent(item: JSON) -> GCalEvent{
        var title = ""
        var description = ""
        var location = ""
        var startDate:NSDate = NSDate()
        var endDate:NSDate = NSDate()
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
            startDate = Utils.parseRCF339Date(itemStart, dateOnly: false)
        }
        
        if let itemStart = item["start"]["date"].string {
            startDate = Utils.parseRCF339Date(itemStart, dateOnly: true)
        }
        
        
        if let itemEnd = item["end"]["dateTime"].string{
            endDate = Utils.parseRCF339Date(itemEnd, dateOnly: false)
        }
        
        if let itemEnd = item["end"]["date"].string{
            endDate = Utils.parseRCF339Date(itemEnd,dateOnly: true)
        }
            
        
        var gEvent = GCalEvent(title: title, description: description, location: location, startDate: startDate, endDate: endDate)
        
        return gEvent
    }
}