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
    
    class func parseJSONToEvent(){
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/moscroppanthers@gmail.com/events?maxResults=1000&orderBy=startTime&singleEvents=true&key=AIzaSyDQgD1es2FQdm4xTA1tU8vFniOglwe4HsE")
        var request = NSURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            var json = JSON(data: data!)
            if let items = json["items"] as? JSON {
                for var index = 0; index < items.count; ++index {
                    print(items[index])
                }
            }
        })
        task.resume()
    }
}