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
    var duration = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        var date = Utils.dateToComponents(NSDate())
        month = Utils.convertNumToMonth(date.month)
        day = date.day
        self.navigationItem.title = String(date.year - 1) + "-" + String(date.year)
        monthButton.title = month
//        CalendarParser.parseJSON { (events) -> () in
//            self.events = events;
////            self.tableView.reloadData()
//            print(Utils.dateToComponents(events[2].endDate).hour)
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadData()
//                var indexPath = NSIndexPath(forRow: self.dateToFirstRow(self.month, day: String(self.day)), inSection: 0)
//                self.tableView.scrollToRowAtIndexPath(indexPath,
//                    atScrollPosition: UITableViewScrollPosition.Top, animated: false)
//            }
//        }
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "CalendarEvent")
        let fetchResults = managedContext!.executeFetchRequest(fetchRequest, error: &error)
        
        if let CalEvents = fetchResults{
            if CalEvents.count > 0 {
                for CalEvent in CalEvents {
                    var title:String = CalEvent.valueForKey("title") as! String
                    var desc:String = CalEvent.valueForKey("desc") as! String
                    var location:String = CalEvent.valueForKey("location") as! String
                    var startDate:NSDate = CalEvent.valueForKey("startDate") as! NSDate
                    var endDate:NSDate = CalEvent.valueForKey("endDate") as! NSDate
                    events.append(GCalEvent(title: title, description: desc, location: location, startDate: startDate, endDate: endDate))
                }
                events.sort({ (event1: GCalEvent, event2: GCalEvent) -> Bool in
                    if (Utils.sameDay(event1.startDate, endDate: event2.startDate)){
                        return event1.title < event2.title
                    } else {
                        return Utils.isLessDate(event1.startDate, date2: event2.startDate)
                    }
                })
                
                var indexPath = NSIndexPath(forRow: self.dateToFirstRow(self.month, day: String(self.day)), inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
            
        }else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        

        
        
        self.tableView.reloadData()
        
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("calendar", forIndexPath: indexPath) as! CalendarTableViewCell
    
        
        cell.titleLabel.text = events[indexPath.row].title
        cell.descriptionLabel.text = events[indexPath.row].description
        var day = String(Utils.dateToComponents(events[indexPath.row].startDate).day)
        day = Utils.addZeroSingleDigit(day)
        cell.dayLabel.text = day
        
        var weekDay = Utils.weekdayToTag(Utils.dateToWeekday(events[indexPath.row].startDate))
        var substring: String = weekDay.substringToIndex(advance(weekDay.startIndex, 3))
        cell.weekLabel.text = substring
        
        duration = "All Day"
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
            
        if ThemeManager.currentTheme() == ThemeType.Black {
            alert.view.tintColor = UIColor.blackColor();
        }
            
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows() as? [NSIndexPath] {
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
                    var indexPath = NSIndexPath(forRow: self.dateToFirstRow(self.month, day: ""), inSection: 0)
                    self.tableView.scrollToRowAtIndexPath(indexPath,
                        atScrollPosition: UITableViewScrollPosition.Top, animated: false)

                }
            }
        }

    }
    
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
                var eventDate = events[fast].startDate
                if Utils.isEqualToDate(eventDate, date2: NSDate()){
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
