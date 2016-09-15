//
//  ViewController.swift
//  Calculator
//
//  Created by Luke Holoubek on 9/1/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController{
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        
        print("Transitioning to graph")
////        if let graphViewController = destinationvc as? GraphViewController {
////            print("going to send program: \(String(calculator.program))")
//            graphViewController.vcProgram = calculator.program as! [AnyObject]
////        }
    }

    // Create a new calculator to use from the associated model
    private var calculator = CalculatorModel()
    
    
    // Called when user selects something other than a digit
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsTyping {
            calculator.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let operation = sender.currentTitle{
            calculator.performOperations(operation)
        }
        displayValue = calculator.result
        displayDescription = calculator.description
    }
    
    // Main label showing calculator output
    @IBOutlet  private weak var display: UILabel!
    
    // Property to track whether the user is entering numbers
    private var userIsTyping = false {
        didSet{
            print("userIsTyping: \(String(userIsTyping))")
        }
    }
    
    // computed property to display whenever this is accessed
    private var displayValue: Double {
        get {
            // Return an optional double when this property is accessed
            if let val = Double(display.text!){
                return val
            }
                // If we can't pull the value (for example, if the user merely entered a . -
            else {
                return 0
            }
        }
        set {
            // use newValue keyword for computed property
            display.text = String(newValue)
        }
    }

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let textDisplayed = display.text!
        // If the user is typing, continue appending additional values
        if userIsTyping{
            display.text = textDisplayed + digit
        } else {
            display.text = digit
        }
        userIsTyping = true
    }
    
    @IBAction func setVar(sender: UIButton) {
        // Sets a variable to the calculator
        calculator.variableValues["M"] = displayValue
        
        if let operation = sender.currentTitle{
            calculator.performOperations(operation)
        }
        userIsTyping = false
        displayValue = calculator.result
        displayDescription = calculator.description
    }
    
    
    @IBAction func useVar(sender: UIButton) {
        if sender.currentTitle != nil{
            calculator.setOperand(sender.currentTitle!)
        }
        
        userIsTyping = false
        displayValue = calculator.result
        displayDescription = calculator.description
    }
    
    @IBAction func provideFloat(sender: UIButton) {
        let dot = sender.currentTitle!
        let textDisplayed = display.text!
        if userIsTyping{
            if textDisplayed.containsString(dot){
                return
            } else {
                display.text = textDisplayed + dot
            }
        } else {
            display.text = dot
        }
        userIsTyping = true
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var displayDescription: String {
        get {
            return " "
        }
        set {
            if String(newValue).characters.count < 1 { // If the description is empty we should clear it
                descriptionLabel.text = " "
            } else if calculator.isPartialResult{
                descriptionLabel.text = String(newValue) + " ..."
            } else {
                descriptionLabel.text = String(newValue) + " ="
            }
        }
    }
}

