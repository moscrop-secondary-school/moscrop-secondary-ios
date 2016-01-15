//
//  Utils.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 9/19/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Utils {
    
    class func currentTimeMillis() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    

    class func checkConnection() -> NetworkStatus {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus().value

        if (networkStatus == ReachableViaWiFi.value){
            return NetworkStatus.WiFiConnection
        } else if (networkStatus == ReachableViaWWAN.value){
            return NetworkStatus.WWANConnection
        } else {
            return NetworkStatus.NoConnection
        }
        
    }
    
    class func getRelativeTime(date: NSDate) -> String {

        var timestamp = ""
        
        let millis: Int64 = Int64(date.timeIntervalSince1970 * 1000)
        let nowMillis = currentTimeMillis()
        let diffMillis = nowMillis - millis
        
        if diffMillis < 60*60*1000 {
            let minAgo = diffMillis / (60*1000)
            timestamp = "\(minAgo) minutes ago"
        } else if diffMillis < 24*60*60*1000 {
            let hoursAgo = diffMillis / (60*60*1000)
            timestamp = "\(hoursAgo) hours ago"
        } else if diffMillis < 7*24*60*60*1000 {
            // TODO use something like Java calendar to count days
            let daysAgo = diffMillis / (24*60*60*1000)
            timestamp = "\(daysAgo) days ago"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd"
            timestamp = formatter.stringFromDate(date)
        }
        
        return timestamp
    }
    
    class func getDate() -> NSDateComponents {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit
        let components = calendar.components(unitFlags, fromDate: date) as NSDateComponents
        return components
    }
    
    class func convertNumToMonth(num :Int) -> String {
        var month = ""
        switch num {
        case 1:
            month = "January"
        case 2:
            month = "February"
        case 3:
            month = "March"
        case 4:
            month = "April"
        case 5:
            month = "May"
        case 6:
            month = "June"
        case 7:
            month = "July"
        case 8:
            month = "August"
        case 9:
            month = "September"
        case 10:
            month = "October"
        case 11:
            month = "November"
        case 12:
            month = "December"
        default:
            month = "January"
        }
        return month
    }
    
    class func createJsonFromString(jsonString: String) -> JSON {
        let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        return JSON(data: dataFromString)
    }
}
