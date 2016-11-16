//
//  GameView.swift
//  breakout
//
//  Created by Luke Holoubek on 11/6/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

class GameView: UIView {

    // This view displays the breakout game
    
    func setUpGame(gameSettings: GameSettings){
        layoutBlocks(numBlocks: gameSettings.numberOfBlocks)
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
            print("origin: \(origin)")
            
            let frame = CGRect(origin: origin, size: blockSize)
            let blockView = UIView(frame: frame)
            blockView.backgroundColor = UIColor.blue
            addSubview(blockView)
        }
        
    }
    
    
}
