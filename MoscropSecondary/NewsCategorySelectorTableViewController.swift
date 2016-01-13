//
//  NewsCategorySelectorTableViewController.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 9/20/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit

class NewsCategorySelectorTableViewController: UITableViewController {

    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var subscribedCategories = [String]()
    var allCategories = [String]()
    var selectedCategory: String?
    
    var editMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadCategories()
    }
    
    func loadCategories() {
        subscribedCategories.removeAll(keepCapacity: false)
        subscribedCategories = ["Subscribed", "All"]
        subscribedCategories += ParseCategoryHelper.getSubscribedTagNames()
        
        allCategories.removeAll(keepCapacity: false)
        allCategories += ParseCategoryHelper.getAllTagNames()
        allCategories = allCategories.filter() { $0 != "Official" }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if editMode {
            return allCategories.count
        } else {
            return subscribedCategories.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categorySelectorCell", forIndexPath: indexPath) as! NewsCategorySelectorTableViewCell

        // Configure the cell...
        if editMode {
            cell.nameLabel.text = allCategories[indexPath.row]
            if contains(subscribedCategories, allCategories[indexPath.row]) {
                cell.nameLabel.textColor = UIColor.blackColor()
            } else {
                cell.nameLabel.textColor = UIColor.lightGrayColor()
            }
        } else {
            cell.nameLabel.text = subscribedCategories[indexPath.row]
            cell.nameLabel.textColor = UIColor.blackColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? NewsCategorySelectorTableViewCell {
            if editMode {
                if contains(subscribedCategories, allCategories[indexPath.row]) {
                    subscribedCategories = subscribedCategories.filter() { $0 != self.allCategories[indexPath.row] }
                    cell.nameLabel.textColor = UIColor.lightGrayColor()
                } else {
                    subscribedCategories += [allCategories[indexPath.row]]
                    cell.nameLabel.textColor = UIColor.blackColor()
                    
                }
            } else {
                performSegueWithIdentifier("unwindToPostList", sender: cell)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func edit(sender: UIBarButtonItem) {
        if editMode {
            
            // Sort the subscribed tags alphabetically
            subscribedCategories.sort { (s1: String, s2: String) -> Bool in
                if s1 == "Official" {
                    return true
                } else if s2 == "Official" {
                    return false
                } else {
                    return s1 < s2
                }
            }
            
            subscribedCategories = subscribedCategories.filter() { $0 != "Subscribed" }
            subscribedCategories = subscribedCategories.filter() { $0 != "All" }
            
            // Save subscribed tags
            let preferences = NSUserDefaults.standardUserDefaults()
            preferences.setObject(subscribedCategories, forKey: "subscribed_tags")
            
            subscribedCategories = ["Subscribed", "All"] + subscribedCategories
            
            // Update UI
            editMode = false
            navigationItem.leftBarButtonItem?.enabled = true
            sender.title = "Edit"
            tableView.reloadData()
            
        } else {
            editMode = true
            navigationItem.leftBarButtonItem?.enabled = false
            sender.title = "Save"
            cancelButton.title = "Done"
            tableView.reloadData()
        }
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let selectedCell = sender as? NewsCategorySelectorTableViewCell, selectedPath = self.tableView.indexPathForCell(selectedCell) {
            if !editMode {
                selectedCategory = subscribedCategories[selectedPath.row]
            }
        }
    }

}
