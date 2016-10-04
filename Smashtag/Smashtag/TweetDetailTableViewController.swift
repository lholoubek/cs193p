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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var tweetDetail: TweetDetail?
   
    // MARK: - Table view data source
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
        
        print("MENTION TYPE: \(mentionType!)")
        
        
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
            myCell.url = myUrl
        }
        return cell
    }
    

}
