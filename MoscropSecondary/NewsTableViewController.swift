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

class NewsTableViewController: UITableViewController {

    let cellIdentifier = "newsTableViewCell"
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadFeed()
    }

    func loadFeed() {
        var query = PFQuery(className:"BlogPosts")
        query.whereKey("category", notEqualTo: "")
        query.orderByDescending("published")
        query.limit = 24
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.posts.removeAll(keepCapacity: false)
                
                if let objects = objects as? [PFObject] {
                    self.posts = Array(objects.generate())
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
        return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell

        // Configure the cell...
        let post = posts[indexPath.row]
        
        if let title = post["title"] as? String {
            cell.titleLabel.text = title
        }
        if let category = post["category"] as? String {
            cell.categoryLabel.text = category
        }
        if let date = post["published"] as? NSDate {
            cell.timestampLabel.text = Utils.getRelativeTime(date)
        }
        
        if let bgImage = post["bgImage"] as? String {
            var url: NSURL?
            if bgImage != "@null" {
                url = NSURL(string: bgImage)
                cell.thumbnailImageView.layer.cornerRadius = 10
            } else {
                if let icon = post["icon"] as? String {
                    url = NSURL(string: icon)
                    cell.thumbnailImageView.layer.cornerRadius = 37
                }
            }
            
            if url != nil {
                cell.thumbnailImageView.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "Placeholder.png"))
            }
        }
        
        return cell
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowNewsDetail" {
            let newsDetailViewController = segue.destinationViewController as! NewsDetailViewController
            if let selectedCell = sender as? NewsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedPost = posts[indexPath.row]
                newsDetailViewController.post = selectedPost
            }
        }
    }


}
