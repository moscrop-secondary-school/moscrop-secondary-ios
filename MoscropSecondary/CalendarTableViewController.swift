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
    var month = "January"

    override func viewDidLoad() {
        super.viewDidLoad()
        var date = Utils.getDate()
        month = Utils.convertNumToMonth(date.month)
        monthButton.title = month
        CalendarParser.parseJSONToEvent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
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
