//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/16/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: CoreDataTableViewController {

//    var managedObjectContext: NSManagedObjectContext? {
//        didSet {
//            updateUI()
//        }
//    }
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Ask for the delegate from the UIApplication
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext  // main queue
    }()
    
    var mention: String? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let context = managedObjectContext {
            if (mention?.characters.count)! > 0 {
                let request: NSFetchRequest = NSFetchRequest<Mention>(entityName: "Mention")
                request.predicate = NSPredicate(format: "any searchTerm.term = %@", mention!)
                request.sortDescriptors = [NSSortDescriptor(
                    key: "count",
                    ascending: false
                )]
                fetchedResultsController = NSFetchedResultsController<Mention>(
                    fetchRequest: request,
                    managedObjectContext: context,
                    sectionNameKeyPath: nil,
                    cacheName: nil)
            } else {
                fetchedResultsController = nil
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularityCell", for: indexPath) as! MentionPopularityTableViewCell
        
        if let mention = fetchedResultsController?.object(at: indexPath) {
            // We now have our mention. Let's extract data from it and drop it in the cell
            // NOTE: data retrieval going on here. Must do on the proper queue using performBlock()
            var mentionString: String?
            var mentionNumber: String?
            
            mention.managedObjectContext?.performAndWait {
                mentionString = mention.content
                mentionNumber = "\(String(mention.count)) mentions"
            }
            
            cell.mentionLabel.text = mentionString
            cell.mentionNumberLabel.text = mentionNumber
        
        }
        
        return cell
        
    }
    
    override func viewDidLoad() {
        updateUI()
    }


}
