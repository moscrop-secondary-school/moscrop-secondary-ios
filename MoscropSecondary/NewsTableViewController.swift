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
