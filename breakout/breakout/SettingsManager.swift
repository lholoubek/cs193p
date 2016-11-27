//
//  GameSettings.swift
//  breakout
//
//  Created by Luke Holoubek on 11/19/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import Foundation

enum BallSpeed: Double {
    case fast = 0.14
    case medium = 0.08
    case slow = 0.05
}

class SettingsManager {
    
    static let sharedInstance = SettingsManager()
    
    var gameInProgress = false
    
    var ballSpeed: BallSpeed = .slow
    
    var numBlocks = 25
    
    var useTilt = false
    
    var randomness: Int = 15
    
    func resetDefaults() {
        ballSpeed = .slow
        numBlocks = 25
        useTilt = false
        randomness = 0
    }
    
}
