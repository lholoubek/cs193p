//
//  GraphView.swift
//  Calculator
//
//  Created by Luke Holoubek on 9/13/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit


@IBDesignable
class GraphView: UIView {

    override func drawRect(rect: CGRect) {
        // If graphOrigin has not been set, initialize it to the center of the bounds
        // NOTE: We have to do this here because bounds aren't available until now
        if graphOrigin == nil {
            graphOrigin = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        if valFromPixel != nil {
            print("Here's where we'll use the valFromPixel function provided by the controller...")
        }
        
        //contentScaleFactor isn't available until now
        drawer.contentScaleFactor = contentScaleFactor
        drawer.drawAxesInRect(bounds, origin: graphOrigin!, pointsPerUnit: graphScale)
    }
    
    @IBInspectable
    var graphOrigin: CGPoint?{
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var graphScale: CGFloat = 37.0 { didSet{ setNeedsDisplay() } }
    
    //MARK: Public API
    // Optional function to call when drawing to return a value for the passed pixel
    var valFromPixel: ((Int) -> (Float))?
    
    struct AxisValues {
        var max: Float
        var min: Float
    }
    
    var xAxisVals: AxisValues {
        let maxX = Float(bounds.maxX)/2
        let minX = 0 - (Float(bounds.maxX)/2)
        return AxisValues(max: maxX/Float(graphScale), min: minX/Float(graphScale))
    }
    
    
    // MARK: Gesture Handlers
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            graphScale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func changeOrigin(recognizer: UIPanGestureRecognizer){
        switch recognizer.state{
        case .Changed, .Ended:
            let translation = recognizer.translationInView(self)
            var newOrigin = CGPoint()
            newOrigin.x = graphOrigin!.x + translation.x
            newOrigin.y = graphOrigin!.y + translation.y
            recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), inView: self)
            graphOrigin = newOrigin
        default:
            break
        }
    }
    
    let drawer = AxesDrawer(color: UIColor.blueColor())
    
    func drawAxes(){
        setNeedsDisplay()
    }
    
    
    
    
    
    
}
