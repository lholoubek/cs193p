//
//  SearchTerm+CoreDataClass.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/18/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(SearchTerm)
public class SearchTerm: NSManagedObject {
    
    class func searchTerm(fromTerm term: String, andTweet tweet: Twitter.Tweet, inManagedOBjectContext context: NSManagedObjectContext) -> SearchTerm? {
        // Accepts a search term and a Tweet
        // Creates the SearchTerm and adds to DB
        // uses Mention and Tweet methods to add Mention and Tweets to DB
        
        let searchTermRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchTerm")
        searchTermRequest.predicate = NSPredicate(format: "term = %@", term)
        
        // see if this searchTerm exists in the DB
        if let searchTerm = (try? context.fetch(searchTermRequest))?.first as? SearchTerm {
            
            if TweetRecord.tweetRecordExists(forTweet: tweet, withTerm: searchTerm.term!, inManagedContext: context) {
                print("previous search term and tweet found")
                return searchTerm
            } else {  //we have a searchTerm but this tweet hasn't been processed yet
                let tweetRecord = TweetRecord.tweetRecord(forTweet: tweet, inManagedContext: context)
                print("adding new tweet")
                // Add this Tweet record
                searchTerm.addToTweets(tweetRecord!)
                
                // Add mentions for the Tweet
                for user in tweet.userMentions {
                    let newMention = Mention.createOrIncrementMentionFrom(mentionString: user.keyword, searchTerm: searchTerm, managedObjectContext: context)
                    searchTerm.addToMentions(newMention!)
                }
                for hashtag in tweet.hashtags {
                    let newMention = Mention.createOrIncrementMentionFrom(mentionString: hashtag.keyword, searchTerm: searchTerm, managedObjectContext: context)
                    searchTerm.addToMentions(newMention!)
                }
                return searchTerm
            }
        } else {
            // New search term! Create a new search term
            let searchTerm = SearchTerm(context: context)
            print("new search term!!")
            searchTerm.term = term
            
            // add the tweet
            let newTweet = TweetRecord.tweetRecord(forTweet: tweet, inManagedContext: context)
            searchTerm.addToTweets(newTweet!)
            
            // Add mentions for the Tweet
            for user in tweet.userMentions {
                let newMention = Mention.createOrIncrementMentionFrom(mentionString: user.keyword, searchTerm: searchTerm, managedObjectContext: context)
                searchTerm.addToMentions(newMention!)
            }
            for hashtag in tweet.hashtags {
                let newMention = Mention.createOrIncrementMentionFrom(mentionString: hashtag.keyword, searchTerm: searchTerm, managedObjectContext: context)
                searchTerm.addToMentions(newMention!)
            }
            
            print("finished making new search term –––––– ")
            print(searchTerm)
            
            return searchTerm
            
        }
    }
        
}
