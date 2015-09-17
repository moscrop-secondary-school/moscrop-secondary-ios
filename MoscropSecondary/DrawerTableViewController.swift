//
//  DrawerTableViewController.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 8/23/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerTableViewController: UITableViewController {

    // MARK: Properties
    var currentPosition = 0
    var sections = Dictionary<Int, [DrawerItem]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the navigation items
        loadDrawerItems()
    }
    
    func loadDrawerItems() {
        
        let itemIcons0 = ["News", "Newsletter", "Event", "Teacher"]
        let itemTexts0 = ["News", "Newsletters", "Events", "Teachers"]
        var items0 = [DrawerItem]()
        for i in 0..<itemIcons0.count {
            let icon = UIImage(named: itemIcons0[i])!
            let item = DrawerItem(icon: icon, text: itemTexts0[i])
            items0 += [item]
        }
        sections[0] = items0
        
        let itemIcons1 = ["Settings", "About", "Contact"]
        let itemTexts1 = ["Settings", "About", "Contact Us"]
        var items1 = [DrawerItem]()
        for i in 0..<itemIcons1.count {
            let icon = UIImage(named: itemIcons1[i])!
            let item = DrawerItem(icon: icon, text: itemTexts1[i])
            items1 += [item]
        }
        sections[1] = items1
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = sections[section] {
            return items.count
        }
        else {
            println("Unknown section \(section)")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DrawerTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DrawerTableViewCell
        
        if indexPath.section != 0 && indexPath.row == 0 {
            cell.drawerSectionDivider.hidden = false
        }
        else {
            cell.drawerSectionDivider.hidden = true
        }
        
        if let items = sections[indexPath.section] {
            // Fetches the appropriate meal for the data source layout.
            let item = items[indexPath.row]
            
            cell.drawerItemIcon.image = item.icon
            cell.drawerItemText.text = item.text
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let drawerController = parentViewController as? KYDrawerController {
            if indexPath.section == 0 {
                if indexPath.row != currentPosition {
                    var destViewControllerId: String
                    switch indexPath.row {
                    case 0:
                        destViewControllerId = "NewsNavigation"
                    case 1:
                        destViewControllerId = "NewsletterNavigation"
                    case 2:
                        destViewControllerId = "EventNavigation"
                    case 3:
                        destViewControllerId = "TeacherNavigation"
                    default:
                        destViewControllerId = "NewsNavigation"
                    }
                    let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(destViewControllerId) as! UIViewController
                    drawerController.mainViewController = destViewController
                    currentPosition = indexPath.row
                }
            }
            else if indexPath.section == 1 {
                // Do other stuff
                if let items = sections[1] {
                    let item = items[indexPath.row]
                    println("Selected \(item.text)")
                }
                performSegueWithIdentifier("settings", sender: self)
            }
            drawerController.setDrawerState(.Closed, animated: true)
        }
    }
    
}
