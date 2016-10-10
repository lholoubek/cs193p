//
//  ImageDetailViewController.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/9/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image != nil {
            imageView = UIImageView(image: image)
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        // Initialize here - this will only get called once and keeps viewDidLoad cleaner
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 9.0
        }
    }
}

extension ImageDetailViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
