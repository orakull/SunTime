//
//  Hand.swift
//  SunTime
//
//  Created by Руслан Ольховка on 12.01.15.
//  Copyright (c) 2015 Руслан Ольховка. All rights reserved.
//

import UIKit

@IBDesignable class Hand: UIView
{
    @IBInspectable var length: CGFloat = 60
    @IBInspectable var width: CGFloat = 1
    @IBInspectable var color: UIColor = UIColor.whiteColor()
    @IBInspectable var offsetLength: CGFloat = 20
    @IBInspectable var degree: CGFloat = 0
//    @IBInspectable var shadowEnabled: Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let top = CGPointMake(rect.width / 2, rect.height / 2 - self.length)
        let bottom = CGPointMake(rect.width / 2, rect.height / 2 + self.offsetLength)
        let path = UIBezierPath()
        path.lineWidth = self.width
        path.moveToPoint(bottom)
        path.addLineToPoint(top)
        self.color.set()
        path.stroke()
        
        Hand.rotateHand(self, degree: self.degree)
    }
    
    class func rotateHand(hand: UIView, degree:CGFloat)
    {
        UIView.animateWithDuration(1.0, animations:
            { () -> Void in
                hand.transform = CGAffineTransformMakeRotation(degree * CGFloat(M_PI) / 180)
        })
    }
}

