//
//  ParseCacheHelper.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 10/4/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import Foundation
import Parse
import Bolts
import SwiftyJSON

/*extension JSON {
    public init (_ jsonArray:[JSON]) {
        self.init(jsonArray.map { $0.object })
    }
}*/

class ParseCacheHelper {
    
    static let ONLINE_CACHE_AGE_THRESHOLD = 10*60*1000  // 10 minutes
    
    static let CACHE_MAP_FILE = "cache_map_file.json"
    static let DEFAULT_CACHE_MAP_JSON = "{\"cacheList\":[]}"
    
    class func getCachePolicyForId(id: String) -> PFCachePolicy {
        
        if (Utils.checkConnection() == 0) {
            return .CacheOnly
        }
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            
            let dir = dirs[0]
            let path = dir.stringByAppendingPathComponent(CACHE_MAP_FILE)
            let cacheListStr = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) ?? DEFAULT_CACHE_MAP_JSON
            
            var jsonObject = Utils.createJsonFromString(cacheListStr)
            var cacheArray = jsonObject["cacheList"].arrayValue
            
            let now = Utils.currentTimeMillis()
            let limit = now - ONLINE_CACHE_AGE_THRESHOLD
            
            for cacheItem:JSON in reverse(cacheArray) {
                if cacheItem["timestamp"].int64Value > limit {
                    if cacheItem["id"].stringValue == id {
                        // We found it. There exists a cache
                        // of this post that is relatively new.
                        
                        var query = PFQuery(className:"Posts")
                        query.selectKeys(["content"])
                        query.whereKey("objectId", equalTo: id)
                        if query.hasCachedResult() {
                            return .CacheOnly
                        } else {
                            // Cache is missing.
                            // No need to remove from tracker,
                            // chances are it will be added back almost immediately.
                            // Simply tell app to load from network again.
                            return .NetworkOnly
                        }
                    }
                } else {
                    // All posts after this will be older
                    // since we are looping form newest -> oldest.
                    // Therefore, no point in continuing.
                    break
                }
            }
            
        }
        
        return .NetworkOnly
    }
    
    class func addCacheForId(id: String, withTimestamp timestamp: Int64) {
        
        /**
         * The list of caches is sorted by timestamp in ascending order.
         * E.g. the first post is the oldest, and the last post is the newest
         */
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            
            let dir = dirs[0]
            let path = dir.stringByAppendingPathComponent(CACHE_MAP_FILE)
            let cacheListStr = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) ?? DEFAULT_CACHE_MAP_JSON
            //let cacheListStr = "{\"cacheList\":[{\"timestamp\":1444018495015,\"id\":\"test1444018495015\"}]}"
            
            var jsonObject = Utils.createJsonFromString(cacheListStr)
            var cacheArray = jsonObject["cacheList"].arrayValue
            
            var alreadyStoredInPosition = -1
            for i in 0..<cacheArray.count {
                var cacheItem = cacheArray[i]
                if cacheItem["id"].stringValue == id {
                    // Already cached. We will update the timestamp later
                    alreadyStoredInPosition = i
                }
            }
            
            if alreadyStoredInPosition != -1 {
                var cacheItem = cacheArray.removeAtIndex(alreadyStoredInPosition)
                cacheItem["timestamp"].int64 = timestamp
                cacheArray.append(cacheItem)
            } else {
                // If item is not yet cached, add a new category
                let cacheItem = Utils.createJsonFromString("{\"timestamp\":\(timestamp),\"id\":\"\(id)\"}")
                cacheArray.append(cacheItem)
                
                // Save maximum of 1000 caches
                // Remove the oldest caches first
                while cacheArray.count > 1000 {
                    let deletedCache = cacheArray.removeAtIndex(0)  // Delete the tracker reference
                    deleteCache(deletedCache)                       // Remove the actual cache file
                }
            }
            
            jsonObject["cacheList"] = JSON(cacheArray)
            
            // Save JSONObject to file
            if let string = jsonObject.rawString() {
                string.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
            }
        }
    }
    
    private class func deleteCache(deletedCache: JSON) {
        let id = deletedCache["id"].stringValue
        var query = PFQuery(className:"Posts")
        query.selectKeys(["content"])
        query.whereKey("objectId", equalTo: id)
        query.clearCachedResult()
    }
    
}
