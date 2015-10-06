//
//  ParseCategoryHelper.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 10/5/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import Foundation
import Parse
import Bolts
import SwiftyJSON

class ParseCategoryHelper {
    
    static let TAG_LIST_JSON_BUNDLE = "categories"
    static let TAG_LIST_JSON_DOCUMENTS = "categories.json"
    
    struct Category {
        var name = ""
        var id = ""
    }
    
    private class func getRootJsonObject() -> JSON {
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            
            let dir = dirs[0]
            let path = dir.stringByAppendingPathComponent(TAG_LIST_JSON_DOCUMENTS)
            
            let checkValidation = NSFileManager.defaultManager()
            if !checkValidation.fileExistsAtPath(path) {
                copyFromBundleToDocuments()
            }
            
            let jsonStr = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) ?? "{}"
            return Utils.createJsonFromString(jsonStr)
            
        }
        return Utils.createJsonFromString("{}")
    }
    
    private class func copyFromBundleToDocuments() {
        
        // Read from bundle
        let bundlePath = NSBundle.mainBundle().pathForResource(TAG_LIST_JSON_BUNDLE, ofType: "json")
        let jsonStr = String(contentsOfFile: bundlePath!, encoding: NSUTF8StringEncoding, error: nil) ?? "{}"
        
        // Write to documents
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            
            let dir = dirs[0]
            let path = dir.stringByAppendingPathComponent(TAG_LIST_JSON_DOCUMENTS)
            jsonStr.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    
    class func getFilterCategoriesForTag(tag: String) -> [PFObject] {
        var categories: [Category]?
        switch tag {
        case "All":
            categories = getAllTags()
        case "Subscribed":
            categories = getSubscribedTags()
        default:
            let category = findCategoryByName(tag)
            if category != nil {
                categories = [category!]
            }
        }
        
        if categories != nil {
            var filterObjects = [PFObject]()
            for category in categories! {
                var filterObject = PFObject(className: "Categories")
                filterObject.objectId = category.id
                filterObjects.append(filterObject)
            }
            return filterObjects
        } else {
            return [PFObject]()
        }
    }
    
    class func findCategoryByName(name: String) -> Category? {
        let root = getRootJsonObject()
        let tags = root["tags"].arrayValue
        for tag in tags {
            if tag["name"].stringValue == name {
                return Category(name: tag["name"].stringValue, id: tag["id"].stringValue)
            }
        }
        return nil
    }
    
    class func getAllTags() -> [Category] {
        let root = getRootJsonObject()
        let tags = root["tags"].arrayValue
        var categories = [Category]()
        for tag in tags {
            if tag["name"].stringValue != "Student Bulletin" {
                let category = Category(name: tag["name"].stringValue, id: tag["id"].stringValue)
                categories.append(category)
            }
        }
        return categories
    }
    
    class func getAllTagNames() -> [String] {
        let categories = getAllTags()
        var names = [String]()
        for category in categories {
            names.append(category.name)
        }
        
        // Use custom comparator because we want
        // "Official" to remain at the top of the list
        names.sort { (s1: String, s2: String) -> Bool in
            if s1 == "Official" {
                return true
            } else if s2 == "Official" {
                return false
            } else {
                return s1 > s2
            }
        }
        
        return names
    }
    
    class func getSubscribedTags() -> [Category] {

        let allCategories = getAllTags()
        
        // Get a list of tags the user subscribed to
        let preferences = NSUserDefaults.standardUserDefaults()
        let existingSelectedValues = (preferences.arrayForKey("subscribed_tags") as? [String]) ?? ["Official"]
        
        var subscribedCategories = [Category]()
        
        for value in existingSelectedValues {
            for category in allCategories {
                if category.name == value {
                    subscribedCategories.append(category)
                }
            }
        }
        
        return subscribedCategories
    }
    
    class func getSubscribedTagNames() -> [String] {
        
        // Get a list of recognized tags
        let tagNamesArray = getAllTagNames()
        
        // Get a list of tags the user subscribed to
        let preferences = NSUserDefaults.standardUserDefaults()
        let existingSelectedValues = (preferences.arrayForKey("subscribed_tags") as? [String]) ?? ["Official"]
        
        var subscribedTags = [String]()
        for value in existingSelectedValues {
            for tag in tagNamesArray {
                if tag == value {
                    subscribedTags.append(tag)
                }
            }
        }
        
        subscribedTags.sort { (s1: String, s2: String) -> Bool in
            if s1 == "Official" {
                return true
            } else if s2 == "Official" {
                return false
            } else {
                return s1 > s2
            }
        }
        
        return subscribedTags
    }
    
    private static let CATEGORIES_LIST_UPDATE_MIN_WAIT = 5*60*1000  // 5 minutes
    
    class func downloadCategoriesList(endAction: Void -> Void) {
        
        let preferences = NSUserDefaults.standardUserDefaults()
        let lastUpdate = Int64(preferences.doubleForKey("categories_updated_at") ?? 0)
        
        if Utils.currentTimeMillis() - lastUpdate > CATEGORIES_LIST_UPDATE_MIN_WAIT {
            preferences.setDouble(Double(Utils.currentTimeMillis()), forKey: "categories_updated_at")
            preferences.synchronize()
            
            PFCloud.callFunctionInBackground("getCategoriesLastUpdatedTime", withParameters: nil) {
                (response: AnyObject?, error: NSError?) -> Void in
                if error == nil {
                    let millis = Int64(response as! Double)
                    let lastVersion = Int64(preferences.doubleForKey("categories_version") ?? 0)
                    
                    // Only download tags if there is a newer version.
                    if millis > lastVersion {
                        var query = PFQuery(className:"Categories")
                        query.orderByAscending("name")
                        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                            if let objects = objects as? [PFObject] {
                                var root = Utils.createJsonFromString("{}")
                                var tags = [JSON]()
                                for object in objects {
                                    let name = object["name"] as! String
                                    let id = object.objectId
                                    let tag = Utils.createJsonFromString("\"name\":\"\(name)\",\"id\":\"\(id)\"")
                                    tags.append(tag)
                                }
                                root["tags"] = JSON(tags)
                                
                                if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
                                    
                                    let dir = dirs[0]
                                    let path = dir.stringByAppendingPathComponent(self.TAG_LIST_JSON_DOCUMENTS)
                                    if let string = root.rawString() {
                                        string.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
                                    }
                                }
                            }
                        }
                    }
                }
                // Call closure
                endAction()
            }
        } else {
            // Call closure
            endAction()
        }
        
    }
    
}