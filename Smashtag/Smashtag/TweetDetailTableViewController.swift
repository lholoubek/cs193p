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
    
    var tweet: Twitter.Tweet?
    
    var tweetDetail: TweetDetail?
   
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let details = tweetDetail {
            return details.sections.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let details = tweetDetail {
            return details.sections[section]
        } else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "default")
        cell.textLabel?.text = "hooray"
        return cell
    }
}
