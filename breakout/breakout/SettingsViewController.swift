//
//  BreakoutSettingsViewController.swift
//  breakout
//
//  Created by Luke Holoubek on 11/6/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let settingsManager = SettingsManager.sharedInstance
    
    // MARK: Outlets
    @IBOutlet weak var difficultySelector: UISegmentedControl!
    @IBOutlet weak var tiltControlSwitch: UISwitch!
    @IBOutlet weak var cellStepper: UIStepper! {
        didSet{
            cellStepper.value = Double(settingsManager.numBlocks)
        }
    }
    @IBOutlet weak var blockCountLabel: UILabel! {
        didSet{
            updateBlockCount()
        }
    }
    private func updateBlockCount(){
        blockCountLabel.text = "\(settingsManager.numBlocks) blocks"
    }
    
    @IBOutlet weak var bouncySlider: UISlider! {
        didSet{
            bouncySlider.minimumValue = 0.0
            bouncySlider.maximumValue = 1.0
        }
    }

    @IBOutlet weak var bounceSlider: UISlider!{
        didSet {
            bounceSlider.value = Float(settingsManager.randomness)
        }
    }
    
    // MARK: Actions
    @IBAction func difficultySelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                print("set To Easy")
                settingsManager.ballSpeed = .slow
            case 1:
                print("set to medium")
                settingsManager.ballSpeed = .medium
            case 2:
                print("set to hard")
            settingsManager.ballSpeed = .fast
        default:
            break
        }
    }
    
    @IBAction func handleTiltSwitch(_ sender: UISwitch){
        print("toggled tilt switch")
        settingsManager.useTilt = sender.isOn
    }
    
    @IBAction func handleBlockStepperUpdate(_ sender: UIStepper){
        settingsManager.numBlocks = Int(sender.value)
        updateBlockCount()
        print("Num blocks adjusted: \(settingsManager.numBlocks)")
    }
    
    @IBAction func handleBouncySliderUpdate(_ sender: UISlider){
        settingsManager.randomness = Int(sender.value)
    }
    
    @IBAction func handleResetDefaults(_ sender: UIButton){
        resetSettings()
    }
    
    private func resetSettings(){
        settingsManager.resetDefaults()
        difficultySelector.selectedSegmentIndex = settingsManager.ballSpeed.hashValue
        tiltControlSwitch.isOn = settingsManager.useTilt
        cellStepper.value = Double(settingsManager.numBlocks)
        updateBlockCount()
        bounceSlider.value = Float(settingsManager.randomness)
    }    
    
    // MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("updated settings: \(settingsManager)")
        cellStepper.minimumValue = 0.0
        cellStepper.maximumValue = 30.0
        cellStepper.stepValue = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // User is leaving settings. Update the gameSettings in the global settingsManager
//        settingsManager.gameSettings = newSettings
        
        
    }
    

   
}



