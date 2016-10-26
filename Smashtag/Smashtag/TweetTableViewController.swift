//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    // MARK: Model

//    var tweets = [Array<Twitter.Tweet>]()
//    var tweets = [[Twitter.Tweet]]
    
    var tweets: [[Twitter.Tweet]] = [[]]
    {
        didSet {
            print("values set!")
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
            addItemToHistory(term: searchText!)
        }
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Ask for the delegate from the UIApplication
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext  // main queue
    }()
    
    // MARK: Fetching Tweets
    
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if let query = searchText , !query.isEmpty {
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets()
    {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                print("fetched tweets: \(newTweets.count) in total")
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            // Add the tweets to our local var
                            for tweeter in newTweets {
                                print("Tweeter: \(tweeter)")
                            }
                            self?.tweets.insert(newTweets, at: 0)
                            // Process the tweets through the database to inform mention popularity view
                            self?.addDataToDatabase(tweets: newTweets)
                        }
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        searchForTweets()
    }
    
    private func addDataToDatabase(tweets: [Twitter.Tweet]) {
        managedObjectContext.perform {
            if let term = self.searchText {
                // Process each tweet through the DB
                for tweet in tweets {
                    _ = SearchTerm.searchTerm(fromTerm: term, andTweet: tweet, inManagedOBjectContext: self.managedObjectContext)
                }
                do {
                    try self.managedObjectContext.save()
                } catch let error {
                    print("error: \(error)")
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource

//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "\(tweets.count - section)"
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
            
            let tweet = tweets[indexPath.section][indexPath.row]
            if let tweetCell = cell as? TweetTableViewCell {
                tweetCell.tweet = tweet
            }
            
            return cell
    }
    
    // MARK: Constants
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
    
    // MARK: Outlets

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let idenfitier = segue.identifier {
            switch idenfitier{
            case "ToDetail":
                // in this case sender is a TableViewCell
                if let cell = sender as? TweetTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let detailViewController = segue.destination as? TweetDetailTableViewController{
                    print("SEGUEING - ")
                    let tweet = tweets[indexPath.section][indexPath.row]
                    let tweetDetail = tweetDetailFromTweet(tweet: tweet)
                    print("TWEET DETAIL---- \(tweetDetail)")
                    detailViewController.tweetDetail = tweetDetail
                }
            default:
                break
            }
        }
    }
    
}
