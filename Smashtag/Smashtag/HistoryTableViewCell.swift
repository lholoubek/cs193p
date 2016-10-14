//
//  HistoryTableViewCell.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchTextLabel: UILabel!
    
    var searchHistoryText: String? {
        didSet{
            searchTextLabel.text = searchHistoryText
        }
    }

}
