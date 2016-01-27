//
//  MoreTableViewController.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2015-10-11.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    var more = ["Settings", "About", "Contact Us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
        self.tableView.tableFooterView = UIView.new()
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moreCell", forIndexPath: indexPath) as! MoreTableViewCell
        cell.moreHeader.text = more[indexPath.row]
        
        return cell
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
        return more.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0
        {
            self.performSegueWithIdentifier("settings", sender: self)
        }
        else if indexPath.row == 1
        {
            self.performSegueWithIdentifier("about", sender: self)
        }
        else if indexPath.row == 2
        {
            let email = "moscropsecondarydev@gmail.com" //Contact Us Email
            let url = NSURL(string: "mailto:\(email)")
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
