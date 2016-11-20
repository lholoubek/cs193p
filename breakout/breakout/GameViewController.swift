//
//  GameViewController.swift
//  breakout
//
//  Created by Luke Holoubek on 11/6/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit


class GameViewController: UIViewController {

    let settingsManager = SettingsManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("New game controller!")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("we're back - update for settings")
        print("num blocks: \(settingsManager.numBlocks)")
        gameView.setUpGame(numBlocks: settingsManager.numBlocks)
    }
    
    @IBOutlet weak var gameView: GameView! {
        didSet {
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            gameView.addGestureRecognizer(panRecognizer)
        }
    }
    @IBOutlet weak var paddle: PaddleView!
    
    func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state{
        case .changed:
            let translation = gesture.translation(in: gameView)
            gesture.setTranslation(CGPoint.zero, in: gameView)
            let horizontalPan = translation.x
            movePaddle(movement: horizontalPan)
        case .ended:
            gesture.setTranslation(CGPoint.zero, in: gameView)
        default:
            break
        }
    }
    
    
    func movePaddle(movement: CGFloat) {
        
        
        let currentX = paddle.frame.minX
        let totalWidth = gameView.bounds.width
        let movingLeft = movement < 0.0 ? true : false
        
        var newX: CGFloat = 0.0
        
        if movingLeft {
            newX = currentX + movement
            if newX < 0 {
                newX = 0
            }
        } else {
            newX = currentX + movement
            if newX + paddle.bounds.maxX > totalWidth {
                newX = totalWidth - paddle.bounds.maxX
            }
        }
        let newOrigin = CGPoint(x: newX, y: paddle.frame.minY)
        
        print("movement: \(movement)  CurrentX: \(currentX)  NewX: \(newX)")
        
        paddle.frame = CGRect(origin: newOrigin, size: paddle.bounds.size)
    }
    

}
