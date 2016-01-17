//
//  CalendarTableViewController.swift
//  
//
//  Created by Jason Wong on 2016-01-14.
//
//

import UIKit

class CalendarTableViewController: UITableViewController {
    
    @IBOutlet var monthButton: UIBarButtonItem!
    var month = "September"
    var events: [GCalEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        var date = Utils.dateToComponents(NSDate())
        month = Utils.convertNumToMonth(date.month)
        monthButton.title = month
        CalendarParser.parseJSON { (events) -> () in
            self.events = events;
            self.tableView.reloadData()
            print(Utils.dateToComponents(events[0].startDate))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarCell") as! CalendarTableViewCell
        
        cell.titleLabel.text = events[indexPath.row].title
        cell.descriptionLabel.text = events[indexPath.row].description
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
        return events.count
    }
    
    @IBAction func unwindToPostList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MonthTableViewController, selectedMonth = sourceViewController.selectedMonth {
            if month != selectedMonth {
                month = selectedMonth
                monthButton.title = selectedMonth
            }
        }

    }
    


}
