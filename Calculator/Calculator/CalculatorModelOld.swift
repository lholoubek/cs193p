//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Luke Holoubek on 9/3/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import Foundation


// Necessary so we can specify a function for
func multiply(op1: Double, op2: Double)-> Double{
    return op1 * op2
}

func divide(op1: Double, op2: Double)->Double {
    return op1/op2
}

// Model for conducting calculations
class CalculatorModelOld {
    
    private var accumulator = 0.0
    
    private var operations: Dictionary<String, Operation> = [
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
        "C":Operation.Clear,
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
        case Clear
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        if !isPartialResult {
            updateAccumulatedDescription(description + String(accumulator), clear: true)
        }
    }
    
    private var pendingOp: PendingBinaryOperation?
    
    var isPartialResult: Bool {
        get {
            return pendingOp != nil
        }
    }
    
    private struct PendingBinaryOperation{
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
    }
    
    func performOperations(operation: String){
        if let operationToPerform = operations[operation]{
            
            switch operationToPerform {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function):
                if pendingOp != nil {
                    updateAccumulatedDescription(description + operation + "(\(accumulator))", clear: true)
                } else {
                    updateAccumulatedDescription(operation + "(\(description))", clear: true)
                }
                accumulator = function(accumulator)
//                updateAccumulatedDescription("", clear: true)
            case .BinaryOperation(let function):
                if isPartialResult {
                    updateAccumulatedDescription(description + String(accumulator), clear: true)
                } else {
//                    updateAccumulatedDescription(description + " \(operation) " + String(accumulator), clear: true)
                    updateAccumulatedDescription(description + " \(operation) ", clear: true)
                }
                
                executePendingBinaryOperation()
                pendingOp = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                updateAccumulatedDescription(description + String(accumulator), clear: true)
                executePendingBinaryOperation()
            case .Clear:
                accumulator = 0.0
                updateAccumulatedDescription("", clear: true)
                pendingOp = nil
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pendingOp != nil{
            accumulator = pendingOp!.binaryFunction(pendingOp!.firstOperand, accumulator)
            pendingOp = nil
        }
    }
    
    // result of operation
    // NOTE: this is implemented as a computed property BUT only the get method is implemented! That prevents this from being set externally
    var result: Double{
        get {
            return accumulator
        }
    }
    
    private var accumulatedDescription: String?
    
    private func updateAccumulatedDescription(update: String, clear: Bool){
        // We need to clear and reset this to the update string
        if clear {
            accumulatedDescription = update
        } else {
            if accumulatedDescription == nil {
                accumulatedDescription = update
            } else {
                accumulatedDescription! += " " + update
            }
        }
        print("accumulatedDescription: \(accumulatedDescription!)")
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