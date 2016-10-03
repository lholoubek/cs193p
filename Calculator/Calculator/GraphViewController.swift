//
//  GraphViewController.swift
//  Calculator
//
//  Created by Luke Holoubek on 9/13/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

var grapherCount = 0

class GraphViewController: UIViewController {
    
    @IBOutlet weak var middleLabel: UILabel!
    
    
    @IBOutlet weak var graphView: GraphView! {
        didSet{  // Called when view is created right before viewDidLoad()
            // Set up pinch/zoom recognizers here
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: graphView, action: #selector(GraphView.changeScale(_:))
            ))
            
            // Enable panning
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(graphView.changeOrigin(_:))
            ))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphCalculator.program = vcProgram
        print(graphCalculator.result)
        middleLabel.text = "Result: \(String(graphCalculator.description))"
        graphView.getYPointFromPixel = getYPointFromPixel
        grapherCount += 1
        print("Number of Graphers: \(grapherCount)")
    }
    
    private let graphCalculator = CalculatorModel()
    
    //MARK: API to ingest data from Calculator view
    var vcProgram = [AnyObject]()
    
    func getValAtPixel(pixel: Int, origin: CGPoint)->Float{
        let numPixels = graphView.contentScaleFactor * graphView.bounds.maxX
        let numValues = (numPixels/graphView.contentScaleFactor)/graphView.graphScale
        let originInPixels = Float(origin.x*graphView.contentScaleFactor)
        let positiveVals = Float(numValues) * ((Float(numPixels) - originInPixels)/Float(numPixels))
        let negativeVals = (Float(numValues) - positiveVals)
        let distFromOriginInPixels = abs(Float(pixel) - originInPixels)
        var portionOfValsOnSideOfOrigin = Float()
        var pixelValue = Float()
        if Float(pixel) < originInPixels {
            portionOfValsOnSideOfOrigin = distFromOriginInPixels/originInPixels
            pixelValue = -(portionOfValsOnSideOfOrigin * negativeVals)
        } else {
            portionOfValsOnSideOfOrigin = distFromOriginInPixels/(Float(numPixels) - originInPixels)
            pixelValue = portionOfValsOnSideOfOrigin * positiveVals
        }
        
        graphCalculator.variableValues["M"] = Double(pixelValue)
        graphCalculator.performOperations("→M")
        let result = graphCalculator.result

        return Float(result)
    }
    
    
    func getYPointFromPixel(pixel: Int, origin: CGPoint) -> CGPoint? {
    //Gets a y coordinate point in points using the provided pixel and graphorigin and graphScale
        let yValue = getValAtPixel(pixel, origin: origin)
//        let originInPixels = Float(origin.y*graphView.contentScaleFactor)
//        let totalPixels = graphView.bounds.maxY * graphView.contentScaleFactor
        
        var returnVal: CGPoint? = nil
  
        
        let totalValues = graphView.bounds.maxY/graphView.graphScale
        let positiveVals = (origin.y/graphView.bounds.maxY) * totalValues
        let negativeVals = -(totalValues - positiveVals)
        if yValue < Float(negativeVals) || yValue > Float(positiveVals) || yValue == 0.0 {
            return returnVal
        }
        
        let yPixel: Float?
        if yValue > 0 {
            let proportionOfPosVals = yValue/Float(positiveVals)
            let positivePixels = Float(origin.y * graphView.contentScaleFactor)
            let pixelDistanceFromOrigin = proportionOfPosVals * positivePixels
            let absolutePixel = Float(origin.y*graphView.contentScaleFactor) - pixelDistanceFromOrigin
            yPixel = absolutePixel
        } else {
            let proportionOfNegVals = abs(yValue)/abs(Float(negativeVals))
            let negativePixels = (graphView.bounds.maxY - origin.y) * graphView.contentScaleFactor
            let pixelDistanceFromOrigin = proportionOfNegVals * Float(negativePixels)
            yPixel = Float(origin.y * graphView.contentScaleFactor) + pixelDistanceFromOrigin
        }
        
        returnVal = CGPoint(x: Double(pixel)/Double((graphView.contentScaleFactor)), y: Double(yPixel!)/Double(graphView.contentScaleFactor))
        
        return returnVal
    
    }
}
