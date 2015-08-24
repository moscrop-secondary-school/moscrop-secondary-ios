//
//  NewsletterViewController.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 8/23/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit
import KYDrawerController

class NewsletterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Actions
    
    @IBAction func didTapOpenDrawerButton(sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            drawerController.setDrawerState(.Opened, animated: true)
        }
    }

}
