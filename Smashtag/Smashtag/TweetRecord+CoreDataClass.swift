//
//  TweetRecord+CoreDataClass.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/18/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(TweetRecord)
public class TweetRecord: NSManagedObject {

    class func tweetRecord(forTweet tweet: Twitter.Tweet, inManagedContext context: NSManagedObjectContext) -> TweetRecord? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetRecord")
        request.predicate = NSPredicate(format: "id = %@", tweet.id)
        
        if let tweetRecord = (try? context.fetch(request))?.first as? TweetRecord {
            print("Found previous tweet")
            return tweetRecord
        } else if let tweetRecord = NSEntityDescription.insertNewObject(forEntityName: "TweetRecord", into: context) as? TweetRecord {
            tweetRecord.content = tweet.description
            tweetRecord.date = tweet.created
            tweetRecord.id = tweet.id
            return tweetRecord
        }
        return nil
    }
    
    class func tweetRecordExists(forTweet tweet: Twitter.Tweet, withTerm term: String, inManagedContext context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetRecord")
        request.predicate = NSPredicate(format: "id = %@", tweet.id)
        if let tweetRecord = (try? context.fetch(request))?.first as? TweetRecord {
            if tweetRecord.searchTerm?.term == term {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
