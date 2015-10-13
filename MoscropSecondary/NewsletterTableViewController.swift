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

class NewsletterTableViewController: PostTableViewController {
    
    override func viewDidLoad() {
        tag = "Student Bulletin"
        super.viewDidLoad()
        navigationItem.title = "Newsletters"
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    func handleSwipe(sender:UISwipeGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        if (sender.direction == .Left) {
            vc.selectedIndex = 2
            self.presentViewController(vc, animated: true, completion: nil)
        }
        if (sender.direction == .Right) {
            vc.selectedIndex = 0
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
}
