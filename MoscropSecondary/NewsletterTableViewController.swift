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
    }
    
}
