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
            print(Utils.dateToComponents(events[2].endDate).hour)
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
        day = Utils.addZeroSingleDigit(day)
        cell.dayLabel.text = day
        
        var weekDay = Utils.weekdayToTag(Utils.dateToWeekday(events[indexPath.row].startDate))
        var substring: String = weekDay.substringToIndex(advance(weekDay.startIndex, 3))
        cell.weekLabel.text = substring
        
        var duration = "All Day"
        var startComponents = Utils.dateToComponents(events[indexPath.row].startDate)
        var startTimeHour = startComponents.hour
        var startTimeMinute = startComponents.minute
        var endComponents = Utils.dateToComponents(events[indexPath.row].endDate)
        var endTimeHour = endComponents.hour
        var endTimeMinute = endComponents.minute
        if !(startTimeHour == 0 && startTimeMinute == 0 && endTimeHour == 0 && endTimeMinute == 0){
            
            
            duration = Utils.createDuration(startTimeHour, startMinute: startTimeMinute, endHour: endTimeHour, endMinute: endTimeMinute)
        }
        
        cell.descriptionLabel.text = duration
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarTableViewCell
        var message = ""
        
        let alert = UIAlertController(title: cell.titleLabel.text, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) {(action) -> Void in
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
        
        alert.addAction(defaultAction)
        
        if ThemeManager.currentTheme() == ThemeType.Black {
            alert.view.tintColor = UIColor.blackColor();
        }
        
        presentViewController(alert, animated: true, completion: nil)
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
