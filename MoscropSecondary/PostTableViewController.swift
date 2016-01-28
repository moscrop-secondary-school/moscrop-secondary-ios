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

class PostTableViewController: UITableViewController {
    
    let cellIdentifier = "postTableViewCell"
    var posts = [PFObject]()
    var tag = "Subscribed"  // default
    var refresher: UIRefreshControl!
    var hasMoreLoad = false
    var wifiChecked = true
    
    func refresh() {
        println("Refresh")
        loadFeed()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        
        // Retrieve NSUserDefaults
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("WifiOnly") != nil) {
            wifiChecked = defaults.boolForKey("WifiOnly")
        }
        
        refresh()
        
    }
    
    func loadFeed(fromLoadMoreCell cell: LoadMoreTableViewCell? = nil) {   // TODO rename so it flows in English
        
        let append = cell != nil
        
        ParseCategoryHelper.downloadCategoriesList { () -> Void in
            
            var query = PFQuery(className: "Posts")
            query.whereKey("category", containedIn: ParseCategoryHelper.getFilterCategoriesForTag(self.tag))
            // TODO select keys
            query.includeKey("category")
            query.orderByDescending("published")
            query.limit = 24
            if append {
                query.skip = self.posts.count
            }
            if Utils.checkConnection() == NetworkStatus.WiFiConnection && Utils.isConnectedToNetwork() {
                query.cachePolicy = .NetworkOnly
            } else if Utils.checkConnection() == NetworkStatus.WWANConnection {
                if self.wifiChecked {
                    query.cachePolicy = .CacheOnly
                } else {
                    query.cachePolicy = .NetworkOnly
                }
            } else {
                query.cachePolicy = .CacheOnly
            }
            
            query.findObjectsInBackgroundWithBlock { (list: [AnyObject]?, error: NSError?) -> Void in
                
                self.refresher.endRefreshing()
                if let cell = cell {
                    self.view.userInteractionEnabled = true
                    cell.spinner.stopAnimating()
                    cell.spinner.hidden = true
                    cell.loadLabel.hidden = false
                }
                
                if error == nil {
                    // Remove empty cache that might get "orphaned"
                    // before we lose a way to delete it.
                    if list == nil || list!.count == 0 {
                        query.clearCachedResult()
                    }
                    
                    if let list = list as? [PFObject] {
                        
                        println("List has \(list.count) items")
                        
                        self.hasMoreLoad = list.count == 24
                        
                        if !append {
                            self.posts.removeAll(keepCapacity: false)
                            // TODO ClearOutdatedCachesTask
                            self.posts = Array(list.generate())
                        } else {
                            self.posts += Array(list.generate())
                        }
                        
                        self.tableView.reloadData()
                    }
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
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
        if self.hasMoreLoad == false {
            return posts.count
        } else {
            return posts.count + 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if (indexPath.row == posts.count) {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("LoadMore", forIndexPath: indexPath) as! LoadMoreTableViewCell
            cell.spinner.hidden = true
            if (!self.hasMoreLoad) {
                cell.hidden = true
            }
            return cell
            
        } else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PostTableViewCell
            // Configure the cell...
            let post = posts[indexPath.row]
            
            if let title = post["title"] as? String {
                cell.titleLabel.text = title
            }
            if let categoryObj = post["category"] as? PFObject {
                if let category =  categoryObj["name"] as? String {
                    cell.categoryLabel.text = category
                }
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
                    if let categoryObj = post["category"] as? PFObject {
                        if let icon = categoryObj["icon_img"] as? String {
                            url = NSURL(string: icon)
                            cell.thumbnailImageView.layer.cornerRadius = 37
                        }
                    }
                }
                
                if url != nil {
                    cell.thumbnailImageView.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "Placeholder.png"))
                }
            }
            return cell
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == posts.count) {
            self.view.userInteractionEnabled = false
            var cell = tableView.cellForRowAtIndexPath(indexPath) as! LoadMoreTableViewCell
            
            cell.loadLabel.hidden = true
            cell.spinner.hidden = false
            cell.spinner.startAnimating()
            
            loadFeed(fromLoadMoreCell: cell)
            
        }
    }
    
    
    
    @IBAction func refreshButtonClicked(sender: UIBarButtonItem) {
        refresh()
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPostDetail" {
            let newsDetailViewController = segue.destinationViewController as! PostDetailViewController
            if let selectedCell = sender as? PostTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedPost = posts[indexPath.row]
                newsDetailViewController.post = selectedPost
            }
        }
    }
    
    
}
