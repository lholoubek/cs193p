//
//  GameViewController.swift
//  breakout
//
//  Created by Luke Holoubek on 11/6/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

struct GameSettings {
    var numberOfBlocks: Int
    var widthOfPaddle: Int
    var speedOfball: Int
}


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameSettings = GameSettings(numberOfBlocks: 23, widthOfPaddle: 50, speedOfball: 1)
        gameView.setUpGame(gameSettings: gameSettings)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var gameView: GameView!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
