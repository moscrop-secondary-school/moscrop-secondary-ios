//
//  SettingTableViewController.swift
//  
//
//  Created by Jason Wong on 2016-01-04.
//
//

import UIKit

class SettingTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var wifiChecked = true;

    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("WifiOnly") != nil) {
            wifiChecked = defaults.boolForKey("WifiOnly")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0){
    
            if wifiChecked == false {
    
                cell.accessoryType = .None
    
            } else if wifiChecked == true {
    
                cell.accessoryType = .Checkmark
    
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            var defaults = NSUserDefaults.standardUserDefaults()
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    wifiChecked = false
                }
                else
                {
                    cell.accessoryType = .Checkmark
                    wifiChecked = true
                }
            }
            defaults.setBool(wifiChecked, forKey: "WifiOnly")
        } else if (indexPath.row == 1){
            self.performSegueWithIdentifier("popoverSegue", sender: self)
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destinationViewController as! UIViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

}
