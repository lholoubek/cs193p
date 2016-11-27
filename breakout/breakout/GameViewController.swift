//
//  GameViewController.swift
//  breakout
//
//  Created by Luke Holoubek on 11/6/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit


class GameViewController: UIViewController{

    let settingsManager = SettingsManager.sharedInstance
    
    var userLostAlertController = UIAlertController(title: "Game over", message:"Game over, you lose.", preferredStyle: .alert)
    var userWonAlertController = UIAlertController(title: "You won!", message: "Congrats, you won.", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ourselves as the BreakoutGameDelegate
        gameView.breakoutGameDelegate = self
        
        // Pass the paddle to the gameView
        gameView.paddle = paddle
        
        // Set up our alerts to show when a game ends
        setUpEndGameAlerts()
    }
    
    func resetGame(){
        gameView.setUpGame(numBlocks: settingsManager.numBlocks)
        gameView.resetBallToHomePosition()
        gameView.updatePaddle(newFrame: paddle.frame)
        gameView.addBoundaries()
    }
    
    private func setUpEndGameAlerts(){
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            print("Action called")
            self.resetGame()
        })
        userLostAlertController.addAction(okAction)
        userWonAlertController.addAction(okAction)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("we're back - update for settings")
        print("num blocks: \(settingsManager.numBlocks)")
        resetGame()
    }
    
    @IBOutlet weak var gameView: GameView! {
        didSet {
            // Pan gesture recognizer to handle paddle panning
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            gameView.addGestureRecognizer(panRecognizer)
            // Tap gesture recognizer to push the ball
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushBall))
            doubleTapRecognizer.numberOfTapsRequired = 2
            gameView.addGestureRecognizer(doubleTapRecognizer)
        }
    }
    @IBOutlet weak var paddle: PaddleView! {
        didSet {
            paddle.backgroundColor = Colors.blue
        }
    }
    @IBOutlet weak var ball: BrickSmasherView! {
        didSet {
            ball.backgroundColor = Colors.red
        }
    }
    
    func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state{
        case .changed:
            let translation = gesture.translation(in: gameView)
            gesture.setTranslation(CGPoint.zero, in: gameView)
            let horizontalPan = translation.x
            movePaddle(movement: horizontalPan)
            gameView.updatePaddle(newFrame: paddle.frame)
        case .ended:
            gesture.setTranslation(CGPoint.zero, in: gameView)
        default:
            break
        }
    }
    
    func pushBall(gesture: UITapGestureRecognizer){
        switch gesture.state{
        case .ended:
            gameView.pushBall()
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
        
        paddle.frame = CGRect(origin: newOrigin, size: paddle.bounds.size)
    }
    
}

extension GameViewController: BreakoutGameDelegate {
    
    func gameEndedUserWon() {
        print("gameEndedUserWon")
        present(userWonAlertController, animated: true, completion: nil)
    }
    
    func gameEndedUserLost() {
        print("gameEndedUserLost")
        present(userLostAlertController, animated: true, completion: nil)
    }
    
}
