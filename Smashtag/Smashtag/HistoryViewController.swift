//
//  HistoryViewController.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchHistory = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshHistory()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func refreshHistory(){
        
        if let searches = NSUserDefaults.standardUserDefaults().arrayForKey(SearchHistoryKey) as? [String] {
            searchHistory = searches
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromHistoryToDetail" {
            if let cell = sender as? HistoryTableViewCell, tweetTableViewController = segue.destinationViewController as? TweetTableViewController{
                print("segue to detail view from history...")
                tweetTableViewController.searchText = cell.searchHistoryText
            }
            
        }
        
    }

}


extension HistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath)
        
        if let historyCell = cell as? HistoryTableViewCell{
            historyCell.searchHistoryText = searchHistory[indexPath.row]
        }
        
        return cell
        
    }
    
    
}
