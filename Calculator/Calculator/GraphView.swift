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
        // NOTE: We have to do this here because bounds aren't available until we're inside the drawRect
        let origin = graphOrigin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        
        //draw the axes using the AxesDrawer class
        drawer.contentScaleFactor = contentScaleFactor
        drawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: graphScale)
        
        // Draw the graph
        if getYPointFromPixel != nil {
        // iterate over pixel and if valid, draw a line to it
            let widthInPixels = bounds.width*contentScaleFactor
            var previousPoint: CGPoint?
            
            for pixel in 0...Int(widthInPixels){
                if previousPoint != nil {
                    let path = UIBezierPath()
                    path.moveToPoint(previousPoint!)
                    if let newPoint = getYPointFromPixel!(pixel: pixel, origin: origin) {
                        path.addLineToPoint(newPoint)
                        path.lineWidth = CGFloat(1.0)
                        path.stroke()
                        previousPoint = newPoint
                    }
                } else {
                    if let newPoint = getYPointFromPixel!(pixel: pixel, origin: origin){
                        previousPoint = newPoint
                    }
                }
            }
            
            
        }
        
        
    }
    
    @IBInspectable
    var graphOrigin: CGPoint?{ didSet {setNeedsDisplay() } }
    
    @IBInspectable
    var graphScale: CGFloat = 37.0 { didSet{ setNeedsDisplay() } }
    
    //MARK: Public API
    // Optional function to call when drawing to return a y axes point for the passed pixel
    var getYPointFromPixel: ((pixel: Int, origin: CGPoint) -> (CGPoint?))?
    
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
        let currentOrigin = graphOrigin ?? CGPoint(x: bounds.midX, y: bounds.midY)

        switch recognizer.state{
        case .Changed, .Ended:
            let translation = recognizer.translationInView(self)
            var newOrigin = CGPoint()
            newOrigin.x = currentOrigin.x + translation.x
            newOrigin.y = currentOrigin.y + translation.y
            recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), inView: self)
            graphOrigin = newOrigin
        default:
            break
        }
    }
    
    let drawer = AxesDrawer(color: UIColor.blueColor())
    
}
