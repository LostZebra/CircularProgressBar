//
//  CircularProgressBar.swift
//  ForTesting
//
//  Created by xiaoyong on 15/4/23.
//  Copyright (c) 2015年 xiaoyong. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    private let fullCircular: Double = M_PI * 2.0
    
    private var isDeterministic: Bool

    private var circularLayer: CAShapeLayer
    
    private var initial: Double?
    private var current: Double?
    
    private var progressIndicator: UILabel?
    
    // Customizable variables
    
    /// Line width of the progressbar
    var lineWidth: CGFloat = 5.0
    /// Fill color of views surrounded by the progressbar
    var fillColor: UIColor = UIColor.clearColor()
    /// Stroke color of the progressbar
    var strokeColor: UIColor = UIColor.orangeColor()
    
    /// Current percentage of the circular progressbar, returns nil if 
    /// the circular progressbar is non-deterministic
    var currentPercentage: Double? {
        get {
            return self.current
        }
    }

    ///Initialize a new instance of CircularProgressBar
    init?(frame: CGRect, isDeterministic: Bool = true, initialPercentage: Double? = 0.0) {
        self.isDeterministic = isDeterministic
        
        // Initialize the layer for the prgressbar
        self.circularLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        // Background color
        self.backgroundColor = UIColor.whiteColor()
        
        if isDeterministic {
            if initialPercentage! < 0 || initialPercentage! > 100.0 {
                return nil
            }
            self.initial = initialPercentage
            self.current = self.initial
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let width = rect.size.width / 2.0
        let center = CGPointMake(width, width)
        
        if (lineWidth > width) {
            lineWidth = width
        }
        
        let radius = width - lineWidth
        let startAngle = CGFloat(-M_PI_2)
        
        var endAngle: CGFloat = CGFloat(self.fullCircular - M_PI_2)
        
        var circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.layer.addSublayer(circularLayer)
        circularLayer.path = circularPath.CGPath
        circularLayer.fillColor = self.fillColor.CGColor
        circularLayer.strokeColor = self.strokeColor.CGColor
        circularLayer.lineWidth = self.lineWidth
        
        circularLayer.strokeStart = 0.0
        circularLayer.strokeEnd = self.current != nil ? CGFloat(self.current!) / 100.0 : 0.0
    }
    
    /// Update the circular progressbar by a deterministic percentage value, if the progressbar has been
    /// previously set to non-deterministic, then there will be no effects at all.
    ///
    /// :param: progress The target percentage value, range from 0 to 100.
    /// :param: animation Indicate whether to render the update process using explicit animation.
    func updateProgress(progress: Double, animation: Bool = true) {
        if isDeterministic {
            if self.current! == progress || progress > 100.0 {
                return
            }
            
            if animation {
                let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                let duration = abs(progress - self.current!) / 100.0
                
                var strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
                strokeEndAnimation.fromValue = CGFloat(self.current!)
                strokeEndAnimation.toValue = CGFloat(progress / 100.0)
                strokeEndAnimation.duration = duration
                strokeEndAnimation.fillMode = kCAFillModeForwards
                strokeEndAnimation.removedOnCompletion = false
                strokeEndAnimation.timingFunction = timingFunction
                
                circularLayer.addAnimation(strokeEndAnimation, forKey: "strokeEndAnimation")
                
//                UIView.transitionWithView(self.progressIndicator!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
//                    self.progressIndicator!.text = String(format: "%d%%", arguments: [Int(progress)])
//                    }, completion: { (completed: Bool) -> Void in
//                    self.progressIndicator!.text = String(format: "%d%%", arguments: [Int(progress)])
//                })
                
                var textTransitionAnimation: CATransition = CATransition()
                textTransitionAnimation.duration = duration
                textTransitionAnimation.type = kCATransitionFade;
                textTransitionAnimation.timingFunction = timingFunction
                progressIndicator!.layer.addAnimation(textTransitionAnimation, forKey: "changeTextAnimation")
                
                // Change the text
                progressIndicator!.text = String(format: "%d%%", arguments: [Int(progress)])
                
                self.current = progress
            }
            else {
                self.current = progress
                self.setNeedsDisplay()
            }
            
            
        }
    }
    
    /// Repeating animation indicating the "In Progress" status for the circular progressbar, if the progressbar 
    /// has been previously set to deterministic, then there will be no effects at all.
    /// 
    /// :param: progressIndicatorText String to be shown when the progressbar is "In Progress", the default value is "...".
    func inProgress(progressIndicatorText: String? = "...") {
        if self.isDeterministic {
            return
        }
        
        var strokeGroupAnimation = CAAnimationGroup()
        strokeGroupAnimation.duration = 3.0
        strokeGroupAnimation.repeatCount = HUGE
        
        var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        var strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 1.0
        strokeEndAnimation.fillMode = kCAFillModeForwards
        strokeEndAnimation.removedOnCompletion = false
        strokeEndAnimation.beginTime = 0.0
        strokeEndAnimation.timingFunction = timingFunction
        
        var strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = 1.0
        strokeStartAnimation.duration = 1.0
        strokeStartAnimation.fillMode = kCAFillModeForwards
        strokeStartAnimation.removedOnCompletion = false
        strokeStartAnimation.beginTime = 1.5
        strokeStartAnimation.timingFunction = timingFunction
        
        strokeGroupAnimation.animations = [strokeEndAnimation, strokeStartAnimation]
        
        circularLayer.addAnimation(strokeGroupAnimation, forKey: "strokeGroupAnimation")
        
        if progressIndicator != nil {
            progressIndicator!.text = progressIndicatorText
        }
    }
    
    /// Add a progess indicator showing the current status of your progess, this indicator can only be added
    /// when the width of spare space is larger than 15.0 (initial width - linewidth).
    ///
    /// :returns: Whether the progress indicator is successfully added.
    func addProgressIndicator() -> Bool {
        let viewWidth = self.bounds.size.width / 2.0
        let center = CGPointMake(viewWidth, viewWidth)
        
        if viewWidth - lineWidth > 15.0 {
            let indicatorWidth = viewWidth - lineWidth - 5.0
            
            progressIndicator = UILabel(frame: CGRectMake(center.x - indicatorWidth, center.y - indicatorWidth, indicatorWidth * 2.0, indicatorWidth * 2.0))
            progressIndicator!.text =
                self.current != nil ? String(format: "%d%%", arguments: [Int(self.current!)]) : "..."
            progressIndicator!.textColor = UIColor.blackColor()
            progressIndicator!.textAlignment = NSTextAlignment.Center
            progressIndicator!.adjustsFontSizeToFitWidth = true
            self.addSubview(progressIndicator!)
            
            return true
        }
        else {
            return false
        }
    }
    
    /// Get the underlying layer for the circular progressbar.
    func getCircularLayer() -> CAShapeLayer {
        return self.circularLayer
    }
    
    /// Remove all animations currently presented.
    func removeAllAnimations() {
        if circularLayer.animationKeys() != nil || circularLayer.animationKeys().count != 0 {
            circularLayer.removeAllAnimations()
            // If current value is still valid
            if self.current != nil {
                circularLayer.strokeEnd = CGFloat(self.current!)
                self.setNeedsDisplay()
            }
        }
    }
    
    /**
     * Ignore this method
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
