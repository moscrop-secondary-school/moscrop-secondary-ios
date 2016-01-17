//
//  CalendarTableViewCell.swift
//  
//
//  Created by Jason Wong on 2016-01-16.
//
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
