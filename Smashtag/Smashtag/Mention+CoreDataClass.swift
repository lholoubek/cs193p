//
//  Mention+CoreDataClass.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/18/16.
//

import Foundation
import CoreData

@objc(Mention)
public class Mention: NSManagedObject {

    class func createOrIncrementMentionFrom(mentionString mentionContent: String, searchTerm term: SearchTerm,  managedObjectContext context: NSManagedObjectContext) -> Mention? {
        // Fetches the object from the DB and increments if it exists
        // Returns a new object if it doesn't exist
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mention")
        request.predicate = NSPredicate(format: "content = %@ AND searchTerm = %@", mentionContent, term)
        
        if let mention = (try? context.fetch(request))?.first as? Mention {
            mention.count += 1
            return mention
        } else {
            let mention = Mention(context: context)
            mention.content = mentionContent
            mention.count = 1
            return mention
        }
    }
}
