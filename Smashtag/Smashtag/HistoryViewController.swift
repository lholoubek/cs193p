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
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        if let searches = UserDefaults.standard.array(forKey: SearchHistoryKey) as? [String] {
            searchHistory = searches
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier!
        
        switch identifier{
        case "FromHistoryToDetail":
            if let cell = sender as? HistoryTableViewCell{
                if let tweetTableViewController = segue.destination as? TweetTableViewController{
                    print("segue to detail view from history...")
                    tweetTableViewController.searchText = cell.searchHistoryText
                }
            }
        case "AccessoryToPopularity":
            if let cell = sender as? HistoryTableViewCell {
                if let popularityTableViewController = segue.destination as? PopularityTableViewController {
                    print("Segueing to popularity view...")
                    popularityTableViewController.mention = cell.searchTextLabel.text
                }
            }
        default:
            return
        }
    }

}


extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
        if let historyCell = cell as? HistoryTableViewCell{
            historyCell.searchHistoryText = searchHistory[indexPath.row]
        }
        
        return cell
        
    }
    
    
}
