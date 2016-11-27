//
//  BreakoutGameDelegate.swift
//  breakout
//
//  Created by Luke Holoubek on 11/27/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import Foundation


protocol BreakoutGameDelegate {
    
    func gameEndedUserWon() -> Void
    
    func gameEndedUserLost() -> Void
}
