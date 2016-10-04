//
//  ImageViewCell.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    var url: NSURL? {
        didSet{
            print("URL: \(url)")
        }
    }
    
    @IBOutlet weak var imageCellImage: UIImageView!
    
}
