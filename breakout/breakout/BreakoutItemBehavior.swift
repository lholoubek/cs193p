//
//  ExplodingBlockBehavior.swift
//  breakout
//
//  Created by Luke Holoubek on 11/20/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit


class BreakoutItemsBehavior: UIDynamicBehavior {
    
    
    let settingsManager = SettingsManager.sharedInstance
    
    // The UIDynamicBehavior object can have child behaviors
    // Overriding the init here associates those child behaviors with the ExplodingBlockBehavior
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(ballItemConfiguration)
        addChildBehavior(ballPushBehavior)
        addChildBehavior(gravityBehavior)
    }
    
    let collisionBehavior: UICollisionBehavior = {
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = false
        return collisionBehavior
    }()
    
    let gravityBehavior: UIGravityBehavior = {
       let behavior = UIGravityBehavior()
        behavior.magnitude = 0.0
        return behavior
    }()
    
    
    // MARK: PUBLIC API
    func addCollisionBehaviorBoundary(path: UIBezierPath, named name: String) {
        collisionBehavior.removeBoundary(withIdentifier: name as NSCopying)
        collisionBehavior.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func addCollisionBehaviorBoundary(from startPoint: CGPoint, to endPoint: CGPoint, name: String){
        collisionBehavior.removeBoundary(withIdentifier: name as NSCopying)
        collisionBehavior.addBoundary(withIdentifier: name as NSCopying, from: startPoint, to: endPoint)
    }
    
    func addBlockItem(item: UIDynamicItem, name: String){
        // Add a block item to the behavior
        brickItemConfiguration.addItem(item)
        //Get the UIBezierPath for the block and add that as a boundary
        addCollisionBehaviorBoundary(path: bezierPathForItem(view: item as! UIView), named: name)
    }
    
    func removeBlockFromAnimator(item: UIDynamicItem, name: NSCopying) {
        // Remove a block from the behavior. I.e., when a block gets busted
        collisionBehavior.removeItem(item)
        brickItemConfiguration.removeItem(item)
        collisionBehavior.removeBoundary(withIdentifier: name)
    }
    
    func addBallItem(ball: UIDynamicItem){
        // add a brick busting ball item to the behavior
        collisionBehavior.addItem(ball)
        gravityBehavior.addItem(ball)
        ballPushBehavior.addItem(ball)
        ballItemConfiguration.addItem(ball)
    }
    
    func pushBall(){
        // Call this to activate the ball push behavior and push the ball in a random direction
        if ballPushBehavior.items.count > 0 {
            ballPushBehavior.setAngle(CGFloat(arc4random()), magnitude: CGFloat(settingsManager.ballSpeed.rawValue))
            ballPushBehavior.active = true
        }
    }
    
    func speedUpBall(ballView: UIDynamicItem){
        print("speedUpBall()")
        print("old velocity: \(ballItemConfiguration.linearVelocity(for: ballView))")
        let currentVelocity = ballItemConfiguration.linearVelocity(for: ballView)
        let newVelocityX = currentVelocity.x * 0.1
        let newVelocityY = currentVelocity.y * 0.1
        
        let velocityToAdd = CGPoint(x: newVelocityX, y: newVelocityY)
        ballItemConfiguration.addLinearVelocity(velocityToAdd, for: ballView)
        print("new velocity: \(ballItemConfiguration.linearVelocity(for: ballView))")
    }
    
    func stopBall(){
        if ballPushBehavior.items.count > 0 {
            ballPushBehavior.active = false
        }
    }
    
    // MARK: Private API
    private let ballItemConfiguration: UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 1.0
        dib.friction = 0.0
        dib.resistance = 0.0
        return dib
    }()
    
    private let brickItemConfiguration: UIDynamicItemBehavior = {
       let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 0.0
        dib.friction = 0.0
        return dib
    }()
    
    private func bezierPathForItem(view: UIView) -> UIBezierPath {
        let pathRect = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.bounds.maxX, height: view.bounds.maxY)
        let path = UIBezierPath(rect: pathRect)
        return path
    }
    
    
    //MARK: Ball push behavior
    private let ballPushBehavior: UIPushBehavior = {
        let behavior = UIPushBehavior(items: [], mode: .instantaneous)
        return behavior
    }()
    
    
    
}
