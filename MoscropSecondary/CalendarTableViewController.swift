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
    var day = 1
    var events: [GCalEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uses current date to calculate the beginning school year and update the navigation item
        let date = Utils.dateToComponents(NSDate())
        month = Utils.convertNumToMonth(date.month)
        day = date.day
        self.navigationItem.title = String(Utils.currentBegSchoolYear()) + "-" + String(Utils.currentBegSchoolYear() + 1)
        
        // Set the Month Button to current month
        monthButton.title = month
        
        // Retrieves calendar events from Core Data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        let error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "CalendarEvent")
        var CalEvents = [NSManagedObject]()
        do {
            CalEvents = try managedContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        
        if CalEvents.count > 0 {
            for CalEvent in CalEvents {
                let title:String = CalEvent.valueForKey("title") as! String
                let desc:String = CalEvent.valueForKey("desc") as! String
                let location:String = CalEvent.valueForKey("location") as! String
                let startDate:NSDate = CalEvent.valueForKey("startDate") as! NSDate
                let endDate:NSDate = CalEvent.valueForKey("endDate") as! NSDate
                // append them to events as GCalEvent
                events.append(GCalEvent(title: title, description: desc, location: location, startDate: startDate, endDate: endDate))
            }
            // Sort the events array so that it displays first in ascending of date, then in ascending of title
            events.sort({ (event1: GCalEvent, event2: GCalEvent) -> Bool in
                if (Utils.sameDay(event1.startDate, endDate: event2.startDate)){
                    return event1.title < event2.title
                } else {
                    return Utils.isLessDate(event1.startDate, date2: event2.startDate)
                }
            })
            
            // Scrolls to first index based on current date
            let indexPath = NSIndexPath(forRow: self.dateToFirstRow(self.month, day: String(self.day)), inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            
        }
        
        
        
        
        self.tableView.reloadData()
        
        
        // Swipe GestureRecognizer
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        // Dynamic Cell Height
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 69.0;
    }
    
    
    func handleSwipe(sender:UISwipeGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        if (sender.direction == .Left) {
            vc.selectedIndex = 3
            self.presentViewController(vc, animated: true, completion: nil)
        }
        if (sender.direction == .Right) {
            vc.selectedIndex = 1
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Displays cell according to the indexPath the cell is on
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("calendar", forIndexPath: indexPath) as! CalendarTableViewCell
        
        
        cell.titleLabel.text = events[indexPath.row].title
        cell.descriptionLabel.text = events[indexPath.row].description
        var day = String(Utils.dateToComponents(events[indexPath.row].startDate).day)
        day = Utils.addZeroSingleDigit(day)
        cell.dayLabel.text = day
        
        let weekDay = Utils.weekdayToTag(Utils.dateToWeekday(events[indexPath.row].startDate))
        let substring: String = weekDay.substringToIndex(weekDay.startIndex.advancedBy(3))
        
        cell.weekLabel.text = substring
        var duration = ""
        duration = "All Day"
        let startComponents = Utils.dateToComponents(events[indexPath.row].startDate)
        let startTimeHour = startComponents.hour
        let startTimeMinute = startComponents.minute
        let endComponents = Utils.dateToComponents(events[indexPath.row].endDate)
        let endTimeHour = endComponents.hour
        let endTimeMinute = endComponents.minute
        // Calculate duration for descriptionLabel
        if !(startTimeHour == 0 && startTimeMinute == 0 && endTimeHour == 0 && endTimeMinute == 0){
            
            duration = Utils.createDuration(startTimeHour, startMinute: startTimeMinute, endHour: endTimeHour, endMinute: endTimeMinute)
        }
        
        cell.descriptionLabel.text = duration
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarTableViewCell
        var message = ""
        var duration = "All Day"
        let startComponents = Utils.dateToComponents(events[indexPath.row].startDate)
        let startTimeHour = startComponents.hour
        let startTimeMinute = startComponents.minute
        let endComponents = Utils.dateToComponents(events[indexPath.row].endDate)
        let endTimeHour = endComponents.hour
        let endTimeMinute = endComponents.minute
        if !(startTimeHour == 0 && startTimeMinute == 0 && endTimeHour == 0 && endTimeMinute == 0){
            
            
            duration = Utils.createDuration(startTimeHour, startMinute: startTimeMinute, endHour: endTimeHour, endMinute: endTimeMinute)
        }
        
        if (events[indexPath.row].location != ""){
            message = "\nDuration\n " + duration + "\n\nLocation\n" + events[indexPath.row].location
        } else {
            message = "\nDuration\n " + duration
        }
        
        
        let alert = UIAlertController(title: cell.titleLabel.text, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) {(action) -> Void in
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
        
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
        if ThemeManager.currentTheme() == ThemeType.Black {
            alert.view.tintColor = UIColor.blackColor()
            
        }
        
    }
    
    // When scroll ended, monthButton is updated
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows! as? [NSIndexPath] {
            if visibleIndexPaths.count > 0 {
                var indexPathRow = visibleIndexPaths[0].row + 1
                
                if indexPathRow < 0 {
                    indexPathRow -= 1
                }
                monthButton.title = (Utils.convertNumToMonth(Utils.dateToComponents(events[indexPathRow].startDate).month))
            }
            
            
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
        return events.count
    }
    
    @IBAction func unwindToPostList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MonthTableViewController, selectedMonth = sourceViewController.selectedMonth {
            if month != selectedMonth {
                month = selectedMonth
                monthButton.title = selectedMonth
                if events.count > 0 {
                    let indexPath = NSIndexPath(forRow: self.dateToFirstRow(self.month, day: ""), inSection: 0)
                    self.tableView.scrollToRowAtIndexPath(indexPath,
                        atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                    
                }
            }
        }
        
    }
    
    // first row is always either on the first date that matches the current date or the one slightly less than the current date
    func dateToFirstRow(month: String, day: String) -> Int{
        if day == "" {
            for var index = 0; index < events.count; ++index {
                if Utils.convertNumToMonth(Utils.dateToComponents(events[index].startDate).month) == month{
                    return index
                }
            }
            return events.count - 1
        } else {
            var fast = 0
            while fast < events.count {
                let eventDate = events[fast].startDate
                if Utils.sameDay(eventDate, endDate: NSDate()){
                    return fast
                } else if Utils.isLessDate(NSDate(), date2: eventDate){
                    return fast - 1
                }
                fast += 1
            }
            
            return events.count - 1
        }
    }
    
    
    
}
