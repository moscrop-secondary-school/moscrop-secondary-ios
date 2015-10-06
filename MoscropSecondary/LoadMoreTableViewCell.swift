//
//  LoadMoreTableViewCell.swift
//  MoscropSecondary
//
//  Created by Jason Wong on 2015-10-05.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {

    @IBOutlet var loadLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
