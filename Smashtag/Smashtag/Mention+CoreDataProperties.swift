//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/18/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData


extension Mention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mention> {
        return NSFetchRequest<Mention>(entityName: "Mention");
    }

    @NSManaged public var content: String?
    @NSManaged public var count: Int16
    @NSManaged public var searchTerm: SearchTerm?

}
