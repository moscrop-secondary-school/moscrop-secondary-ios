//
//  NewsTableViewController.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 9/19/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Kingfisher

class NewsTableViewController: PostTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tag
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left

        view.addGestureRecognizer(leftSwipe)
        
        //Configure NSUserDefaults
        var defaults = NSUserDefaults.standardUserDefaults()
        var wifiOnly = true
        if (defaults.objectForKey("WifiOnly") == nil){
            defaults.setBool(wifiOnly, forKey: "WifiOnly")
        }
    }
    func handleSwipe(sender:UISwipeGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        if (sender.direction == .Left) {
            vc.selectedIndex = 1
            self.presentViewController(vc, animated: true, completion: nil)
        }

    }
    // MARK: - Navigation

    @IBAction func unwindToPostList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NewsCategorySelectorTableViewController, selectedTag = sourceViewController.selectedCategory {
            if tag != selectedTag {
                // A new tag was selected
                tag = selectedTag
                self.navigationItem.title = tag
                loadFeed()
            }
        }
    }
    
}
