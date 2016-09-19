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
    
    
    @IBOutlet weak var graphView: GraphView! {
        didSet{  // Called when view is created right before viewDidLoad()
            // Set up pinch/zoom recognizers here
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: graphView, action: #selector(GraphView.changeScale(_:))
            ))
            
            // Enable panning
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.changeOrigin(_:))
            ))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphCalculator.program = vcProgram
        print(graphCalculator.result)
        middleLabel.text = "Result: \(String(graphCalculator.result))"
        graphView.valFromPixel = myFunc
    }
    
    private let graphCalculator = CalculatorModel()
    
    //MARK: API to ingest data from Calculator view
    var vcProgram = [AnyObject]()
    
    func myFunc(num: Int)->Float{
        return Float(num)*2.0
    }
    
    
    

}
