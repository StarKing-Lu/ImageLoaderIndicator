//
//  CircularLoaderView.swift
//  ImageLoaderIndicator
//
//  Created by lmh on 2018/1/16.
//  Copyright © 2018年 SK. All rights reserved.
//

import UIKit

class CircularLoaderView: UIView {

    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    var progress: CGFloat {
        
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            
            if newValue > 1 {
                circlePathLayer.strokeEnd = 1
            } else if newValue < 0 {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        
    }
    
    
    func configure()  {
        
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = .white
        
        progress = 0
        
    }
    
    func circleFrame() -> CGRect {
        
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        let circlePathBounds = circlePathLayer.bounds
        circleFrame.origin.x = circlePathBounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathBounds.midY - circleFrame.midY
        return circleFrame
        
    }
    
    func circlePath() -> UIBezierPath {
        
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
        
    }
    
    func reveal()  {
        
        backgroundColor = .clear
        progress = 1
        
        circlePathLayer.removeAnimation(forKey: "strokeEnd")
        circlePathLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let finalRadius = sqrt((center.x * center.x) + (center.y * center.y))
        let radiusInset = finalRadius - circleRadius
        let outerRect = circleFrame().insetBy(dx: -radiusInset, dy: -radiusInset)
        let toPath = UIBezierPath(ovalIn: outerRect).cgPath
        
        let fromPath = circlePathLayer.path
        let fromLineWidth = circlePathLayer.lineWidth
        
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circlePathLayer.lineWidth = 2 * finalRadius
        circlePathLayer.path = toPath
        CATransaction.commit()
        
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = fromLineWidth
        lineWidthAnimation.toValue = 2 * finalRadius
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath
        
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1
        
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        groupAnimation.animations = [pathAnimation, lineWidthAnimation]
        groupAnimation.delegate = self
        circlePathLayer.add(groupAnimation, forKey: "strokeWidth")
        
        
        
    }
}
extension CircularLoaderView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        superview?.layer.mask = nil
        
}
}
