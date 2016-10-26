//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter


class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.attributedText = attributedStringFromTweet(tweet: tweet)
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    if let imageData = NSData(contentsOf: profileImageURL as URL) {
                        DispatchQueue.main.async {
                            self?.tweetProfileImageView?.image = UIImage(data: imageData as Data)
                        }
                    }
                }
                
            }
            
            let formatter = DateFormatter()
//
//            if Date().timeIntervalSince: tweet.created) > 24*60*60 {
//                formatter.dateStyle = CFDateFormatterStyle.ShortStyle
//            } else {
//                formatter.timeStyle = CFDateFormatterStyle.ShortStyle
//            }
            
            tweetCreatedLabel?.text = formatter.string(from: tweet.created as Date)
        }

    }
    
}
