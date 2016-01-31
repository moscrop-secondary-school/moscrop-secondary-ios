//
//  MonthTableViewController.swift
//  
//
//  Created by Jason Wong on 2016-01-14.
//
//

import UIKit

class MonthTableViewController: UITableViewController {
    var months = ["September", "October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August"]
    
    var selectedMonth: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return months.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthCell") as! MonthTableViewCell
        
        cell.headerLabel.text = months[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MonthTableViewCell {
            performSegueWithIdentifier("unwindToPostList", sender: cell)
        }
    }
    
    
    @IBAction func cancelClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedCell = sender as? MonthTableViewCell, selectedPath = self.tableView.indexPathForCell(selectedCell) {
            selectedMonth = months[selectedPath.row]
        }
    }
    
    

}
