//
//  ImageViewCell.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tweetDetailImageView: UIImageView!
    
    var detailImage: UIImage? {
        didSet{
            tweetDetailImageView.image = detailImage
        }
    }
    
}
