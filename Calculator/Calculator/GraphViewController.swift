//
//  GraphViewController.swift
//  Calculator
//
//  Created by Luke Holoubek on 9/13/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var middleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Woo! Loaded GraphViewController")
        middleLabel.text = "Yay"
    }
    
    var vcProgram = [AnyObject](){
        didSet{
            middleLabel.text = String(vcProgram)
        }
    }
    
    var calculator = CalculatorModel()
    calculator.program = 
    
    
    
}
