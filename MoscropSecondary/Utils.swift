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
    
    class func dateToComponents(date :NSDate) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond
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
    
    class func parseRCF339Date(dateStr: String, dateOnly: Bool) -> NSDate{
        if (dateStr.hasSuffix("Z")) {         // End in Z means no time zone
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date:NSDate = dateFormatter.dateFromString(dateStr)!
            return date
        } else {
            if(!dateOnly) {     // Proper RCF 3339 format with time zone
                let dateFormatter = NSDateFormatter()
                var substring = dateStr.substringToIndex(advance(dateStr.startIndex, 19))
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let date:NSDate = dateFormatter.dateFromString(substring)!
                return date
            } else {                        // Format uncertain, only take common substring
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var substring: String = dateStr.substringToIndex(advance(dateStr.startIndex, 10))
                let date:NSDate = dateFormatter.dateFromString(dateStr)!
                return date
            }
        }
        return NSDate();
    }
    
    class func isWithinOneDay(startDate: NSDate, endDate: NSDate) -> Bool{
        var startComponents = dateToComponents(startDate)
        var endComponents = dateToComponents(endDate)
        var oneDayFuture: NSDate = addDay(startDate, amount: 1)
        var oneDayFutureComponents = dateToComponents(oneDayFuture)
        
        if (sameDay(startDate, endDate: endDate) || oneDayFutureComponents.day == endComponents.day && oneDayFutureComponents.month == endComponents.month && oneDayFutureComponents.year == endComponents.year){
            return true;
        }
        return false;
    }
    class func sameDay(startDate: NSDate, endDate: NSDate) -> Bool{
        var startComponents = dateToComponents(startDate)
        var endComponents = dateToComponents(endDate)
        return startComponents.day == endComponents.day && startComponents.month == endComponents.month && startComponents.year == endComponents.year
    }
    
    class func addDay(date: NSDate, amount: Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let oneDay = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: amount, toDate: date, options: nil)
        return oneDay!
    }
    class func isLessDate(date1: NSDate, date2: NSDate) -> Bool{
        if date1.compare(date2) == NSComparisonResult.OrderedAscending {
            return true
        }
        
        return false
    }
    
    class func isEqualToDate(date1: NSDate, date2: NSDate) -> Bool{
        var date1components = dateToComponents(date1)
        var date2components = dateToComponents(date2)
        
        return date1components.year == date2components.year && date1components.month == date2components.month && date1components.day == date2components.day
    }
    
    class func dateToWeekday(date: NSDate) -> Int {
        // Sunday = 1; Monday = 2; Tuesday = 3; Wednesday = 4; Thursday = 5; Friday = 6; Saturday = 7
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.WeekdayCalendarUnit, fromDate: date)
        let weekDay = myComponents?.weekday
        return weekDay!
    }
    
    class func weekdayToTag(weekday: Int) -> String {
        var str = ""
        switch weekday{
        case 1:
            str = "Monday"
        case 2:
            str = "Tuesday"
        case 3:
            str = "Wednesday"
        case 4:
            str = "Thursday"
        case 5:
            str = "Friday"
        case 6:
            str = "Saturday"
        case 7:
            str = "Sunday"
        default:
            str = "Missing"
        }
        return str
    }
    
    
    class func createDuration(startHour :Int, startMinute :Int, endHour :Int, endMinute :Int) -> String {
        var startTimeHour = startHour
        var endTimeHour = endHour
        var isAm = true
        
        if (startTimeHour > 12){
            startTimeHour = startTimeHour - 12
        }
        if (endTimeHour > 12){
            endTimeHour = endTimeHour - 12
            isAm = false
            
        }
        var stamp = ""
        var start:String = addZeroSingleDigit(String(startTimeHour)) + ":" + addZeroSingleDigit(String(startMinute))
        var end:String = addZeroSingleDigit(String(endTimeHour)) + ":" + addZeroSingleDigit(String(endMinute))
        
        stamp = start + " - " + end
        
        if (isAm){
            stamp += " am"
        } else {
            stamp += " pm"
        }
        
        return stamp
    }
    
    class func addZeroSingleDigit(num :String) -> String {
        var int = num
        if (int.toInt() < 10){
            int = "0" + int
        }
        return int
    }
    
    
    
    class func createJsonFromString(jsonString: String) -> JSON {
        let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        return JSON(data: dataFromString)
    }
}
