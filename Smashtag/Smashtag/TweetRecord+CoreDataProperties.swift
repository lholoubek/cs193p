//
//  TweetRecord+CoreDataProperties.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/18/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData


extension TweetRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetRecord> {
        return NSFetchRequest<TweetRecord>(entityName: "TweetRecord");
    }

    @NSManaged public var content: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var searchTerm: SearchTerm?

}
