//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/12/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation


let SearchHistoryKey = "SearchHistory"

// Provide a function that takes a search term and writes it asynchronously to NSUserDefaults
func addItemToHistory(term: String){
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var currentHistory = getSearchHistory()
    
    // Remove the last item if the history is full
    if currentHistory.count == 100 {
        currentHistory.removeAtIndex(currentHistory.count - 1)
    }
    
    let copy = currentHistory
    
    // If we've already search for this, remove the previous entry
    for (index, item) in copy.enumerate(){
        if item.capitalizedString == term.capitalizedString{
            currentHistory.removeAtIndex(index)
        }
    }
    
    currentHistory.insert(term, atIndex: 0)
    defaults.setObject(currentHistory, forKey: SearchHistoryKey)
}

// Provide a function that retrieves the current list of search terms from NSUserDefaults
func getSearchHistory() -> [String]{
    let defaults = NSUserDefaults.standardUserDefaults()
    if let searchHistory = defaults.objectForKey(SearchHistoryKey) as? [String] {
        return searchHistory
    } else {
        return [String]()
    }
}





