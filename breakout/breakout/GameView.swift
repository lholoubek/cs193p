//
//  GameView.swift
//  breakout
//
//  Created by Luke Holoubek on 11/6/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    var breakoutGameDelegate: BreakoutGameDelegate?
    
    @IBOutlet weak var ball: BrickSmasherView! {
        didSet{
            ball.layer.cornerRadius = ball.bounds.maxX/2.0
            breakoutItemsMasterBehavior.addBallItem(ball: ball)
        }
    }
    
    let settingsManager = SettingsManager.sharedInstance
    
    var paddle: PaddleView!
    
    var acceleratorBlocks = [String]()
    
    //MARK: Setting up the game
    // Keeping track of all of the blockviews in a separate array so we can remove them later as the block count gets adjusted
    var blockViews = [String:UIView]()
    
    // MARK: Public API
    func setUpGame(numBlocks: Int){
        print("gameView - setUpGame()")
        animator.removeAllBehaviors()
        for (block, _) in blockViews{
            blockViews[block]?.removeFromSuperview()
        }
        acceleratorBlocks.removeAll()
        blockViews.removeAll()
        breakoutItemsMasterBehavior.collisionBehavior.removeAllBoundaries()
        
        layoutBlocks(numBlocks: numBlocks)
        
        // Set the gameView up to handle the collision events between bricks
        breakoutItemsMasterBehavior.collisionBehavior.collisionDelegate = self
        
        animator.addBehavior(breakoutItemsMasterBehavior)
        addBoundaries()
    }
    
    func addBoundaries(){
        // Add a collision boundary for the bottom to detect when the ball is past the paddle
        let bottomLeftPoint = CGPoint(x: frame.minX, y: frame.maxY)
        let bottomRightPoint = CGPoint(x: frame.maxX, y: frame.maxY)
        let topLeft = CGPoint(x: frame.minX, y: frame.minY)
        let topRight = CGPoint(x: frame.maxX, y: frame.minY)
        breakoutItemsMasterBehavior.addCollisionBehaviorBoundary(from: bottomLeftPoint, to: bottomRightPoint, name: "bottom_barrier")
        breakoutItemsMasterBehavior.addCollisionBehaviorBoundary(from: topLeft, to: bottomLeftPoint, name: "left_side")
        breakoutItemsMasterBehavior.addCollisionBehaviorBoundary(from: topLeft, to: topRight, name: "top")
        breakoutItemsMasterBehavior.addCollisionBehaviorBoundary(from: topRight, to: bottomRightPoint, name: "right_side")
    }
    
    func updatePaddle(newFrame: CGRect){
        // Gets the frame of the paddle and adds the new boundary of the paddle to the collision behavior
        // This is a square paddle. Let's use an oval instead to make things more interesting
        let paddleOval = UIBezierPath(ovalIn: newFrame)
        breakoutItemsMasterBehavior.addCollisionBehaviorBoundary(path: paddleOval, named: "paddle")
    }
    
    func resetBallToHomePosition(){
        ball.frame = CGRect(x: 180, y: 543, width: 15, height: 15)
        animator.updateItem(usingCurrentState: ball)
    }
    
    private func layoutBlocks(numBlocks: Int){
        // lays out the grid of blocks using the number passed
        // by default we want the block grid to be 5 rows wide
        // height of the blocks will be .5 * width
        
        let numFullRows = (numBlocks / 5)
        let numBlocksInTopRow = numBlocks % 5
        
        // For each of the full rows, we create a view and set them up
        for row in 1...numFullRows {
            layoutBlockRow(rowNum: row, numBlocks: 5)
        }
        layoutBlockRow(rowNum: numFullRows + 1, numBlocks: numBlocksInTopRow)
        
    }
    
    private func layoutBlockRow(rowNum: Int, numBlocks: Int){
        // creates views and adds them for each block in the row
        
        let blockWidth = bounds.size.width / 5
        let blockHeight = blockWidth / 2
        let viewWidth = blockWidth * 0.9
        let viewHeight = blockHeight * 0.9
        
        let blockSize = CGSize(width: viewWidth, height: viewHeight)
        
        for block in 0..<numBlocks {
            let widthOffset = CGFloat(0.05) * blockWidth
            let xOrigin = (blockWidth * CGFloat(block)) + widthOffset
            let yOrigin = blockHeight * CGFloat(0.1) + (blockHeight * CGFloat(rowNum))
            let origin = CGPoint(x: xOrigin, y: yOrigin)
            let frame = CGRect(origin: origin, size: blockSize)
            let blockView = UIView(frame: frame)
            blockView.backgroundColor = Colors.blue
            addSubview(blockView)
            
            let blockName = String((5*rowNum) + block)
            
            let random = arc4random_uniform(100)
            
            if settingsManager.randomness > Int(random) {
                acceleratorBlocks.append(blockName)
                blockView.backgroundColor = Colors.green
            }
            blockViews[blockName] = blockView
            breakoutItemsMasterBehavior.addBlockItem(item: blockView, name: blockName)
        }
        
    }
    
    func removeBlockFromView(name: String){
        
        if let viewToRemove = blockViews[name] {
            
            viewToRemove.backgroundColor = Colors.red
            
            UIView.animate(withDuration: 0.5, animations: {
                viewToRemove.alpha = 0.0
            }, completion: {
                completed in
                viewToRemove.removeFromSuperview()
            }
        )
        }
    }
    
    func paddleHitAnimation(){
        paddle.backgroundColor = Colors.red
        UIView.animate(withDuration: 0.5){
            self.paddle.backgroundColor = Colors.blue
        }
    }
    
    func endGame(){
        print("endGame()")
        animator.removeAllBehaviors()
        if blockViews.count > 0 {
            breakoutGameDelegate?.gameEndedUserLost()
        } else {
            breakoutGameDelegate?.gameEndedUserWon()
        }
    }
    
    
    //MARK: Animation behavior configuration

    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    let breakoutItemsMasterBehavior = BreakoutItemsBehavior()
    
    //MARK: Push behavior for bouncing ball
    // Get this party started by pushing the paddle
    func pushBall(){
        breakoutItemsMasterBehavior.pushBall()
    }
    
}

extension GameView: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("animator paused")
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("animator resuming")
    }
}

extension GameView: UICollisionBehaviorDelegate{
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let boundaryName = identifier as? String {
            switch boundaryName {
            case "bottom_barrier":
                endGame()
            case "paddle":
                paddleHitAnimation()
            case "left_side", "top", "right_side":
                break
            default:
                // If we hit an accelerator block, we need to add acceleration to the ball and then turn the block blue
                let hitBlock = blockViews[identifier as! String]!
                if acceleratorBlocks.contains(identifier as! String) {
                    hitBlock.backgroundColor = Colors.blue
                    breakoutItemsMasterBehavior.speedUpBall(ballView: ball)
                    acceleratorBlocks.remove(at: acceleratorBlocks.index(of: identifier as! String)!)
                } else {
                    removeBlockFromView(name: identifier as! String)
                    breakoutItemsMasterBehavior.removeBlockFromAnimator(item: blockViews[identifier as! String]!, name: identifier!)
                    blockViews.removeValue(forKey: identifier as! String)
                    print("BlockViews count: \(blockViews.count)")
                    if blockViews.count == 0 {
                        endGame()
                    }
                }
            }
        }
    }
}

struct Colors {
    static let red = UIColor(red:1.00, green:0.09, blue:0.33, alpha:1.0)
    static let blue = UIColor(red:0.14, green:0.48, blue:0.63, alpha:1.0)
    static let green = UIColor(red:0.44, green:0.76, blue:0.70, alpha:1.0)
}

