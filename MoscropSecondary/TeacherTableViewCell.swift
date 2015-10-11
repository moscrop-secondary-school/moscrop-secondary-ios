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
    
    var department: String = ""
    var rooms: Array<String> = []
    var email: String = ""
    var website: String = ""
    var teacherName: String = ""
    
    func combineRooms() -> String{
        var roomString = ""
        var i = 0
        while (i < rooms.count - 1) {
            roomString += rooms[i] + ", "
            i++
        }
        roomString += rooms[rooms.count - 1]
        return roomString
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
