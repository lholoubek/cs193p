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
        if !isPartialResult {
            updateDescription(String(operand), replace: false)
        }
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
        }
    }
    
    private func clear(){
        // Resets the calculator
        accumulator = 0
        pendingOp = nil
        internalProgram.removeAll()
        accumulatedDescription! = ""
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
                accumulator = value
                if isPartialResult{
                    updateDescription(operation, replace: false)
                    omitAccumulatorFromDescription = true
                }
            case .UnaryOperation(let function):
                if isPartialResult{
                    updateDescription("\(operation)(\(accumulator))", replace: false)
                    omitAccumulatorFromDescription = true  // need to omit the accumulator if we want to keep modifying this.
                } else {
                    updateDescription("\(operation)(\(accumulatedDescription!))", replace: true)
                    clearDescription = true
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                if isPartialResult{
                    if !omitAccumulatorFromDescription{
                        updateDescription(String(accumulator) + operation, replace: false)
                    } else {
                        updateDescription(operation, replace: false)
                    }
                } else {
                    updateDescription(operation, replace: false)
                }
                omitAccumulatorFromDescription = false
                executePendingBinaryOperation()
                pendingOp = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator, operation: operation)
            case .Equals:
                if isPartialResult{
                    if !omitAccumulatorFromDescription{
                        updateDescription(String(accumulator), replace: false)
                    }
                } else {
                    accumulatedDescription! = accumulatedDescription!
                }
                omitAccumulatorFromDescription = false
                clearDescription = false
                executePendingBinaryOperation()
            case .SetVar:
                executePendingBinaryOperation()
                // Remove the last element (this operation) before re-executing the program
                internalProgram.removeLast()
                program = internalProgram
                clearDescription = false
            case .UseVar(let varName):
                // Setting a string as the operand creates a variable.
                let variableValue = variableValues[varName] ?? 0.0
                
//                if internalProgram.count > 1 {
//                    let precedingItemInProgram = String(internalProgram.removeAtIndex(internalProgram.count - 2)) ?? ""
//                    if precedingItemInProgram == varName {  // if we added an "M" right before this, remove it and disregard it
//                        print(String(internalProgram))
//                        print("Tried to use a variable too many times!")
//                        if internalProgram.count > 1 {  // lolz hacky
//                            internalProgram.removeLast()
//                        }
//                        break
//                    }
//                }
                accumulator = variableValue
                updateDescription(varName, replace: false)
                omitAccumulatorFromDescription = true
            
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
    
    // MARK: Description
    private var accumulatedDescription: String? = ""
    private var clearDescription = false
    private var omitAccumulatorFromDescription = false
    
    private func updateDescription(update: String, replace: Bool){
        if clearDescription {
            accumulatedDescription! = update
            clearDescription = false
        } else if replace {
            accumulatedDescription! = update
        } else {
            accumulatedDescription! = accumulatedDescription! + update
        }
    }

    var description: String {
        get {
            if let current = accumulatedDescription {
                return current
            } else {
                return ""
            }
        }
    }
    
    
}