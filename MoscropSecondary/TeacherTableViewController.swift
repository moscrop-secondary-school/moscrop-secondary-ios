//
//  TeacherTableViewController.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2015-10-06.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit
import Parse


class TeacherTableViewController: UITableViewController {
    var teachers = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadTeachers()
    }
    func loadTeachers() {
        
        var query = PFQuery(className:"teachers")
        query.includeKey("Dept")
        query.orderByAscending("LastName")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.teachers.removeAll(keepCapacity: false)
                
                if let objects = objects as? [PFObject] {
                    self.teachers = Array(objects.generate())
                }
                self.tableView.reloadData()
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
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
        return self.teachers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teacher", forIndexPath: indexPath) as! TeacherTableViewCell
        let teacher = teachers[indexPath.row]
        
        if let prefix = teacher["Prefix"] as? String{
            if let firstName = teacher["FirstName"] as? String{
                if let lastName = teacher["LastName"] as? String{
                    var teacherName = prefix + ". " + String(firstName[advance(firstName.startIndex, 0)]) + ". " + lastName
                    cell.teacherNameLabel.text = teacherName
                }
            }
            
        
        }
        
        if let dept = teacher["Department"] as? String{
            cell.fieldWorkLabel.text = dept
            var url : NSURL?
                if let deptObj = teacher["Dept"] as? PFObject{
                        if let icon = deptObj["image"] as? String{
                            url = NSURL(string: icon)

                        }
            }
                    
        if url != nil {
            
            cell.fieldImage.layer.cornerRadius = 23.5
            
            cell.fieldImage.kf_setImageWithURL(url!, placeholderImage: UIImage (named: "default_teacher"))

        }
        
            
            
        }
        
        
        // Configure the cell...

        return cell
    }
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 58.0
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
