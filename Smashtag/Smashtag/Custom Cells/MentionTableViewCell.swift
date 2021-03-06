//
//  UsersTableViewCell.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MentionTableViewCell: UITableViewCell {

    var mentionData: String? {
        didSet{
             mentionLabel.text? = mentionData!
            print("Mention data: \(mentionData)")
        }
    }
    
    @IBOutlet weak var mentionLabel: UILabel!

}
