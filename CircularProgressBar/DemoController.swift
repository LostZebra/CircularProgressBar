//
//  ViewController.swift
//  CircularProgressBar
//
//  Created by xiaoyong on 15/4/25.
//  Copyright (c) 2015年 xiaoyong. All rights reserved.
//

import UIKit

class DemoController: UIViewController {
    private var width: CGFloat!
    private var height: CGFloat!
    
    private var circularProgressBar: CircularProgressBar?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("animating"))
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        width = self.view.frame.width
        height = self.view.frame.height
        
        circularProgressBar = CircularProgressBar(frame: CGRectMake(width / 2.0 - 40.0, height / 2.0 - 40.0, 80.0, 80.0), isDeterministic: true)
//        circularProgressBar = CircularProgressBar(frame: CGRectMake(width / 2.0 - 40.0, height / 2.0 - 40.0, 80.0, 80.0), isDeterministic: false)
        circularProgressBar?.addProgressIndicator()
        
        self.view.addSubview(circularProgressBar!)
        
//        circularProgressBar!.inProgress(progressIndicatorText: "Loading")
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("animating"), userInfo: nil, repeats: true)
    }
    
    func animating() {
        if (circularProgressBar?.getCircularLayer().animationKeys() != nil) {
            circularProgressBar?.removeAllAnimations()
        }
        
//                circularProgressBar?.inProgress("Loading")
        circularProgressBar!.updateProgress(circularProgressBar!.currentPercentage! + 1.0, animation: true)
    }
    
//        internal func createCircleLayer() {
//            if circleLayer != nil {
//                return
//            }
//    
//            let lineWidth: CGFloat = 10.0
//    
//            // Setup path
//            let arcCenter: CGPoint = CGPointMake(CGRectGetMidX(ringView.bounds), CGRectGetMidY(ringView.bounds))
//            let radius: CGFloat = fmin(CGRectGetMidX(ringView.bounds), CGRectGetMidY(ringView.bounds)) - lineWidth / 2.0
//            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(-M_PI / 2.0), endAngle: CGFloat(M_PI * 2.0 - M_PI / 2.0), clockwise: true)
//    
//            // Add layer
//            circleLayer = CAShapeLayer()
//            ringView.layer.addSublayer(circleLayer)
//            circleLayer.path = circlePath.CGPath
//            circleLayer.fillColor = UIColor.clearColor().CGColor
//            circleLayer.lineWidth = lineWidth
//            circleLayer.strokeColor = UIColor.orangeColor().CGColor
//    
//            circleLayer.strokeStart = 0.0
//            circleLayer.strokeEnd = 0.0
//        }
//    
//        internal func update() {
//            if circleLayer.strokeEnd != 1.0 {
//                // Animation
//                let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
//                strokeEndAnimation.duration = 1.5
//                strokeEndAnimation.fromValue = 0.0
//                strokeEndAnimation.toValue = 1.0
//                strokeEndAnimation.autoreverses = false
//                strokeEndAnimation.repeatCount = 0.0
//    
//                circleLayer.addAnimation(strokeEndAnimation, forKey: "strokeEndAnimation")
//            }
//            else {
//                timer.invalidate()
//                timer = nil
//            }
//        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

