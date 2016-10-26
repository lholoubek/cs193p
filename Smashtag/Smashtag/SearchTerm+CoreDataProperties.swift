//
//  SearchTerm+CoreDataProperties.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/18/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData


extension SearchTerm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchTerm> {
        return NSFetchRequest<SearchTerm>(entityName: "SearchTerm");
    }

    @NSManaged public var term: String?
    @NSManaged public var mentions: NSSet?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for mentions
extension SearchTerm {

    @objc(addMentionsObject:)
    @NSManaged public func addToMentions(_ value: Mention)

    @objc(removeMentionsObject:)
    @NSManaged public func removeFromMentions(_ value: Mention)

    @objc(addMentions:)
    @NSManaged public func addToMentions(_ values: NSSet)

    @objc(removeMentions:)
    @NSManaged public func removeFromMentions(_ values: NSSet)

}

// MARK: Generated accessors for tweets
extension SearchTerm {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TweetRecord)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TweetRecord)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
