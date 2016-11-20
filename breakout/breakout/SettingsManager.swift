//
//  GameSettings.swift
//  breakout
//
//  Created by Luke Holoubek on 11/19/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import Foundation

//Struct to handle current game settings

enum GameDifficulty {
    case easy
    case medium
    case hard
}


class SettingsManager {
    
    static let sharedInstance = SettingsManager()
    
    var gameInProgress = false
    
    var difficultyLevel:GameDifficulty = .easy
    
    var numBlocks = 25
    
    var useTilt = false
    
    var bounciness: Double = 0.0
    
    func resetDefaults() {
        difficultyLevel = .easy
        numBlocks = 25
        useTilt = false
        bounciness = 0.5
    }
    
}
