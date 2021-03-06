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
    
    // parse JSON from gogoel api
    class func parseJSON(){
        var begSchoolYear = String(Utils.currentBegSchoolYear())
        // Dynamically genereates url according to school year
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/moscroppanthers@gmail.com/events?maxResults=1000&orderBy=startTime&singleEvents=true&timeMin=" + begSchoolYear+"-09-01T00:00:00.000Z&key=AIzaSyDQgD1es2FQdm4xTA1tU8vFniOglwe4HsE")
        var request = NSURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        var array = [GCalEvent]()
        var events = [NSManagedObject]()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil){
                clearEntity()
                var json = JSON(data: data!) 
                if let items = json["items"] as? JSON {
                    for var index = 0; index < items.count; ++index {
                        
                        // creates a temp GCalEvent to store data
                        var gEvent = self.createEvent(items[index])
                        
                        if (Utils.isWithinOneDay(gEvent.startDate, endDate: gEvent.endDate)){

                            var title = gEvent.title
                            var description = gEvent.description
                            var location = gEvent.location
                            var startDate = gEvent.startDate
                            var endDate = gEvent.endDate
                            self.saveEvent(title, desc: description, location: location, startDate: startDate, endDate: endDate)
                            
                        } else {
                            //append more gEvent because it is a multiple days event
                            var title = gEvent.title
                            var description = gEvent.description
                            var location = gEvent.location
                            var startDate = gEvent.startDate
                            var endDate = gEvent.endDate
                            while !Utils.sameDay(startDate, endDate: endDate){
                                self.saveEvent(title, desc: description, location: location, startDate: startDate, endDate: endDate)
                                startDate = Utils.addDay(startDate, amount: 1)
                            }
                            
                        }
                        
                    }
                }
                
            }
        })
        task.resume()
    }
    
    // Clear Entity
    class func clearEntity() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "CalendarEvent")
        
        var myList = (try! managedContext!.executeFetchRequest(request)) as! [NSManagedObject]
        
        
        var bas: NSManagedObject!
        for bas in myList {
            managedContext!.deleteObject(bas as NSManagedObject)
        }
        
        myList.removeAll(keepCapacity: false)
        
        do {
            try managedContext!.save()
        } catch _ {
        }
        
        
    }
    
    // Saves event to Core Data
    class func saveEvent(name: String, desc: String, location: String, startDate: NSDate, endDate: NSDate) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entityForName("CalendarEvent",
            inManagedObjectContext:managedContext!)
        
        let event = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        
        event.setValue(name, forKey: "title")
        event.setValue(desc, forKey: "desc")
        event.setValue(location, forKey: "location")
        event.setValue(startDate, forKey: "startDate")
        event.setValue(endDate, forKey: "endDate")
        
        
        
        var error: NSError?
        do {
            try managedContext!.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    // Create GCalEvent
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