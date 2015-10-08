//
//  TeacherTableViewCell.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2015-10-07.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    @IBOutlet var fieldImage: UIImageView!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var fieldWorkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
