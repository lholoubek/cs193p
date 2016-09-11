//
//  FaceView.swift
//  FaceDrawing
//
//  Created by Luke Holoubek on 9/11/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

let LINE_WIDTH = CGFloat(5.0)

class FaceView: UIView {

    // Scale for our face
    var scale: CGFloat = 0.60
    
    // NOTE: making these a computed property because we can't access bounds of our FaceView until it's instantiated
    // Set the radius
    var faceRadius: CGFloat {
        
        let radius = min(bounds.size.width, bounds.size.height) / 2 * scale
        return radius
        
    }
    
    // API to set smile status
    // 1.0 is full smile, -1.0 is full frown
    //Defaults to 0.0
    let mouthPosition: Double = 0.0
    
    
    // Get center of bounds
    var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct FeatureRatios {
        // These are all type variables (thus the 'static' keyword)
        static let FaceRadiusToEyeOffset: CGFloat = 3
        static let FaceRadiusToEyeRadius: CGFloat = 10
        static let FaceRadiusToMouthWidth: CGFloat = 1
        static let FaceRadiusToMouthHeight: CGFloat = 3
        static let FaceRadiusToMouthOffset: CGFloat = 3
    }

    private enum Eye{
        case Left
        case Right
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint{
        let eyeOffset = faceRadius / FeatureRatios.FaceRadiusToEyeOffset
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath{
        
        let eyeRadius = faceRadius / FeatureRatios.FaceRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        return pathforCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        
    }
    
    private func pathForMouth() -> UIBezierPath{
        let mouthWidth = faceRadius / FeatureRatios.FaceRadiusToMouthWidth
        let mouthHeight = faceRadius / FeatureRatios.FaceRadiusToMouthHeight
        let mouthOffset = faceRadius / FeatureRatios.FaceRadiusToMouthOffset
        
        let mouthRectangle = CGRect(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        
        // set up points to draw the bezier curve for the mouth
        // make sure it's between 1 and -1
        let smileOffset = CGFloat(max(-1, min(mouthPosition, 1))) * mouthRectangle.height
        
        let mouthStart = CGPoint(x: mouthRectangle.minX, y: mouthRectangle.minY)
        let mouthEnd = CGPoint(x: mouthRectangle.maxX, y: mouthRectangle.minY)
        
        // set control points 1/3 of the way across the rectangle containing the mouth
        let mouthCurvePoint1 = CGPoint(x: mouthRectangle.minX + mouthRectangle.width / 3, y: mouthRectangle.minY + smileOffset)
        let mouthCurvePoint2 =  CGPoint(x: mouthRectangle.maxX - mouthRectangle.width / 3, y: mouthRectangle.minY + smileOffset)
        
        
        let smilePath = UIBezierPath()
        smilePath.moveToPoint(mouthStart)
        smilePath.addCurveToPoint(mouthEnd, controlPoint1: mouthCurvePoint1, controlPoint2: mouthCurvePoint2)
        
        smilePath.lineWidth = LINE_WIDTH
        return smilePath
    }
    
    // function to return a path to draw circles
    private func pathforCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat)-> UIBezierPath{
        // takes a center point and radius and gives us a bezier path
        let path =  UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        
        path.lineWidth = LINE_WIDTH
        
        return path
    }
    
    // Note - if not actually drawing, make sure to leave drawRect() commented out
    override func drawRect(rect: CGRect) {
    
        // Use static (class) method on UIColor to set the color. This isn't done on the face object.
        // set() places this as color and stroke. Those can be set individually by other methods.
        UIColor.blueColor().set()
        
        pathforCircleCenteredAtPoint(faceCenter, withRadius: faceRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        
    }
    
    
    
    
    
    
    
}
