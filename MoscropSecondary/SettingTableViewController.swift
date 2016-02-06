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
        // Retrieves NSUserDefault for WifiOnly
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("WifiOnly") != nil) {
            wifiChecked = defaults.boolForKey("WifiOnly")
        }
        
        // Gesture Recognizer
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 58.0;
        
        self.tableView.tableFooterView = UIView()
    }
    
    func handleSwipe(sender:UISwipeGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        if (sender.direction == .Right) {
            vc.selectedIndex = 3
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Displays the checkmark of the cell when wifiChecked is true
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0){
            if ThemeManager.currentTheme() == ThemeType.Black {
                cell.tintColor = UIColor.blackColor()
            }
            
            if wifiChecked == false {
    
                cell.accessoryType = .None
    
            } else if wifiChecked == true {
    
                cell.accessoryType = .Checkmark
    
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            let defaults = NSUserDefaults.standardUserDefaults()

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
        } else if (indexPath.row == 2){
            let email = "moscropsecondarydev@gmail.com" //Contact Us Email
            let url = NSURL(string: "mailto:\(email)")
            UIApplication.sharedApplication().openURL(url!)
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
        return 3
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let index = NSIndexPath(index: 2)
            let cell = tableView.rectForRowAtIndexPath(index)
            let popoverViewController = segue.destinationViewController 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            let popoverPresentation = popoverViewController.popoverPresentationController
            //popoverPresentation!.sourceView = cell
            popoverPresentation!.sourceRect = CGRect(
                x: cell.midX,
                y: 0,
                width: 1,
                height: 1)
            
            popoverPresentation!.permittedArrowDirections  = UIPopoverArrowDirection.Up

        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

}
