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
        self.navigationItem.title = String(date.year - 1) + "-" + String(date.year)
        monthButton.title = month
        CalendarParser.parseJSON { (events) -> () in
            self.events = events;
            self.tableView.reloadData()
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
        var day = String(Utils.dateToComponents(events[indexPath.row].startDate).day)
        if (day.toInt() < 10){
            day = "0" + day
        }
        cell.dayLabel.text = day
        
        var weekDay = Utils.weekdayToTag(Utils.dateToWeekday(events[indexPath.row].startDate))
        var substring: String = weekDay.substringToIndex(advance(weekDay.startIndex, 3))
        cell.weekLabel.text = substring
        
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
