//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
    
    
    // MARK: View Controller lifecycle methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let imageUrls = tweetDetail?.data["images"] else {return}
        
        for url in imageUrls {
            switch url {
            case .Image(let url):
                getImage(url)
            default:
                break
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Public API
    var tweetDetail: TweetDetail?
    
    
    //MARK: Private API
    var images = [UIImage]() {
        didSet{
            // If images have arrived, update the tableview to include the new images
            tableView.reloadData()
        }
    }
    
    private func getImage(url: NSURL){
        // If there's an image, this function retrieves it asynchronously and drops it in the image view
        // Gets the URL from the tweetDetail
        
        print("GETTING URGL: \(url)")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [weak self] in
            if let imageData = NSData(contentsOfURL: url) {
                if let image = UIImage(data: imageData){
                    dispatch_async(dispatch_get_main_queue(), {
                        self?.images.append(image)
                    })
                }
            }
        }
        
    }
}


// MARK: - Table view data source
extension TweetDetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numSections = tweetDetail?.numSections ?? 0
        return numSections
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = tweetDetail?.sections[section]
        return tweetDetail?.data[section!]!.count ?? 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numSections = tweetDetail?.numSections
        if numSections != 0 {
            return tweetDetail?.sections[section] ?? ""
        } else {
            return ""
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("TABLE LOCATION: section-\(indexPath.section)  row-\(indexPath.row) ")
        
        var identifier: String
        
        let section = tweetDetail?.sections[indexPath.section]
        
        let mentionType = tweetDetail?.data[section!]![indexPath.row]
        
        var myString: String? = ""
        var myUrl: NSURL? = NSURL(string: "")
        
        switch mentionType! {
        case .Hashtag(let data):
            identifier = "Mention"
            myString = data
        case .Url(let data):
            identifier = "Mention"
            myString = data
        case .User(let data):
            identifier = "Mention"
            myString = data
        case .Image(let data):
            identifier = "Image"
            myUrl = data
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        if let myCell = cell as? MentionTableViewCell{
            myCell.mentionData = myString!
        } else if let myCell = cell as? ImageViewCell{
            // If we have enough images in the images array for this cell, grab the corresponding image and put it in the cell
            if images.count > indexPath.row {
                myCell.spinner.stopAnimating()
                let image = images[indexPath.row]
                myCell.imageView?.image = image
            } else {
                myCell.spinner.startAnimating()
            }
        }
        return cell
    }
}



//MARK: Table view delegate methods
extension TweetDetailTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = tweetDetail?.sections[indexPath.section]
        let tweet = tweetDetail?.data[section!]?[indexPath.row]
        switch tweet! {
        case .Image:
            // If this is an image, make the cell 200pts by default
            return CGFloat(200.0)
        default:
            // Otherwise constrain it automatically to the size of the text
            return CGFloat(UITableViewAutomaticDimension)
        }
    }
}










