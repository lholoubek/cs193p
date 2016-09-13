//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Luke Holoubek on 9/3/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import Foundation

// Model for conducting calculations
class CalculatorModel {
    
    private var accumulator = 0.0
    
    private var internalProgram = [AnyObject](){// Creating an array with mixes of Doubles and Strings
        didSet {
            if internalProgram.count > 0 {
                print("added to internal program: \(internalProgram[internalProgram.count - 1])")
            }
            print("New internal program: \(String(internalProgram))")
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        // Key/value store to store known operations and associate enums (containing values as needed)
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×":Operation.BinaryOperation({(op1: Double, op2: Double)->Double in op1*op2}),
        "÷":Operation.BinaryOperation({(op1: Double, op2: Double)-> Double in
            op1/op2}),
        "+":Operation.BinaryOperation({$0 + $1}),
        "-":Operation.BinaryOperation({$0 - $1}),
        "=":Operation.Equals,
        "→M":Operation.SetVar,
        "M":Operation.UseVar("M"),
        "C":Operation.Clear,
        "B":Operation.Undo
        ]
    
    private enum Operation {
        // enum for different types of operations with associated values as needed
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
        case SetVar
        case UseVar(String)
        case Clear
        case Undo
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand)  // Add this double to the internal program to be recorded
    }
    
    func setOperand(operand: String){
        performOperations(operand)
    }
    
    var variableValues = Dictionary<String, Double>(){
        didSet{
            print("variableValues updated: \(String(variableValues))")
        }
    }

    private var pendingOp: PendingBinaryOperation?
    
    var isPartialResult: Bool {
        get {
            return pendingOp != nil
        }
    }
    
    typealias PropertyList = AnyObject
    // PropertyList is now AnyObject. Lets anyone using this know that this is AnyObject but also a valid PropertyList
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            // Check if the program they are giving us is valid
            if let providedProgram = newValue as? [AnyObject] {  // is this any array of AnyObject?
                for op in providedProgram {
                    if let operand = op as? Double {  // if we can get this as a double, this is an operand. Set is as the operand.
                        setOperand(operand)
                    }
                    else if let operation = op as? String{  // if we can get this as a string, this is an operation. Run it.
                            performOperations(operation)
                    }
                }
            }
            
            descriptionTracker.resetDescription = false
            descriptionTracker.displayLastOperandInDescription = false
        }
    }
    
    private func clear(){
        // Resets the calculator
        accumulator = 0
        pendingOp = nil
        internalProgram.removeAll()
        descriptionTracker.accumulatedDescription = ""
        descriptionTracker.resetDescription = false
        descriptionTracker.displayLastOperandInDescription = true
    }

    private struct PendingBinaryOperation{
        // This provides a structure for a partially completed binary operation
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
        var operation: String
    }
    
    func performOperations(operation: String){
        
        // by default we want to add all operations to the internal program
        internalProgram.append(operation)  // Add the string operation to the internalProgram to be recorded
        
        if let operationToPerform = operations[operation]{
            
            switch operationToPerform {
            case .Constant(let value):
                updateDescription(operation, clear: false) // add the constant to the description
                descriptionTracker.displayLastOperandInDescription = false // because we're applying the constant, no need to have the binary operation include this
                accumulator = value
            case .UnaryOperation(let function):
                if isPartialResult {
                    updateDescription(operation + "(\(accumulator))", clear: false)
                    descriptionTracker.displayLastOperandInDescription = false
                } else {
                    updateDescription(operation + "(\(description))", clear: true)
                    descriptionTracker.displayLastOperandInDescription = false
                    descriptionTracker.resetDescription = true  // resetDescription mechanism necessary to satisfy requirement (h) of assignment 1 (tricky stuff)
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                
                if isPartialResult{  // if the result is partial, we need to include the current accumulator value
                    updateDescription(String(accumulator) + operation, clear: false)
                }
                    
                else {  // if there is no operation underway, we just put the operation in the description (the accumulator will follow once selected)
                    
                    //handle weird case (h) of assignment 1
                    if descriptionTracker.resetDescription{
                        updateDescription("", clear: true)
                        descriptionTracker.displayLastOperandInDescription = true
                    }
                    
                    if descriptionTracker.displayLastOperandInDescription {
                        updateDescription(String(accumulator) + " " + operation, clear: false)
                    } else {
                        updateDescription(operation, clear: false)
                        descriptionTracker.displayLastOperandInDescription = true
                    }
                }
                executePendingBinaryOperation()
                pendingOp = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator, operation: operation)
            case .Equals:
 
                if descriptionTracker.displayLastOperandInDescription == true {  // in the case of a constant or unary the last operand doesn't need to be displayed when equals is pressed. Example: √(9) = instead of just 3. In this case, it should show the unary operation and operand instead of just the result...
                    updateDescription(String(accumulator), clear: false)
                }
                
                descriptionTracker.displayLastOperandInDescription = false
                executePendingBinaryOperation()
                
            case .SetVar:
                if isPartialResult{
                    if descriptionTracker.displayLastOperandInDescription{  // in the case of a constant or unary, the last operand doesn't need to be displayed when equals is pressed. Example: √(9) = instead of just 3. In this case, it should show the unary operation and operand instead of just the result...
                        updateDescription(String(accumulator), clear: false)
                    }
                    
                    // update - commented out
//                    descriptionTracker.displayLastOperandInDescription = true
                }
                
                // added this for fun
                descriptionTracker.displayLastOperandInDescription = true
                
                executePendingBinaryOperation()
                
                // Remove the last element (this operation) before re-executing the program
                // otherwise we'll get an infinite loop..
                internalProgram.removeLast()
                program = internalProgram
                
            case .UseVar(let varName):
                // Setting a string as the operand creates a variable.
                var variableValue = 0.0
                
                if variableValues[varName] != nil {
                    variableValue = variableValues[varName]!
                }
                
                if descriptionTracker.resetDescription == true{
                    updateDescription(String(varName), clear: true)
                    descriptionTracker.displayLastOperandInDescription = false
                    
                } else {
                    updateDescription(description + String(varName), clear: true)
                    descriptionTracker.displayLastOperandInDescription = false
                }
                
                accumulator = variableValue
                
            case .Clear:
                clear() // Clear the UI and program
                variableValues.removeAll()  // clear any stored variables
            case .Undo:
                internalProgram.removeLast()  // remove "B" from program (added above switch)
                undo()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        // If pendingOp contains a partial binary operation, this function executes it using the saved firstOperator and the value from the accumulator. It then sets the pendingOp to nil, as the previously pending operation has been executed.
        if pendingOp != nil{
            accumulator = pendingOp!.binaryFunction(pendingOp!.firstOperand, accumulator)
            pendingOp = nil
        }
    }
    
    var result: Double{
        get {
            return accumulator
        }
    }
    
    func undo(){
        //  When this method is called, the most recent operand or operation performed is removed from the record and the program is re-run to show the results as they existed before the last event
        print("Undo")
        print("old program: \(String(internalProgram))" )
        let newProgram = internalProgram.dropLast()
        print("New program: \(String(newProgram))")
        program = Array(newProgram) // need to case our new ArraySlice to an Array[AnyObject] to pass to program
    }
    
    // MARK:  Methods and vars for description of operations/operands
    
    private struct CalcDescription {
        // data structure to track the description displaying results of operations
        private var accumulatedDescription: String?  // string used to display operations that have been performed
        private var displayLastOperandInDescription: Bool  // provides logic to omit the last operand in some circumtances
        private var resetDescription: Bool //flag used to have next operation reset the description
    }
    
    private var descriptionTracker = CalcDescription(accumulatedDescription: "", displayLastOperandInDescription: true, resetDescription: false)
    
    private func updateDescription(update: String, clear: Bool){
        // We need to clear and reset this to the update string
        if clear {
            descriptionTracker.accumulatedDescription = update
        } else {
            if descriptionTracker.accumulatedDescription == nil {
                descriptionTracker.accumulatedDescription = update
            } else {
                descriptionTracker.accumulatedDescription! += " " + update
            }
        }
        print("accumulatedDescription: \(descriptionTracker.accumulatedDescription!)")
    }
    
    var description: String {
        get {
            if let current = descriptionTracker.accumulatedDescription {
                return current
            } else {
                return ""
            }
        }
    }
    
    
}