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
    
    class func isConnectedToNetwork() -> Bool {
        
        var status: Bool = false
        let url = NSURL(string:"http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        
        return status
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
    
    class func extractJsonArrayFrom(array: JSON) -> [JSON] {
        var objects:[JSON] = []
        for (index, object):(String, JSON) in array {
            objects.append(object)
        }
        return objects
    }
    
    class func convertArrayToJson(array: [JSON]) -> JSON {
        var str = "["
        for i in 0..<array.count {
            str += array[i].rawString()!
            if i < array.count-1 {
                str += ","
            }
        }
        str += "]"
        return JSON(str)
    }
    
    class func createJsonFromString(jsonString: String) -> JSON {
        let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        return JSON(data: dataFromString)
    }
}
