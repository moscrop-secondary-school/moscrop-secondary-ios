//
//  DrawerTableViewCell.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 8/23/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var drawerItemIcon: UIImageView!
    @IBOutlet weak var drawerItemText: UILabel!
    @IBOutlet weak var drawerSectionDivider: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
