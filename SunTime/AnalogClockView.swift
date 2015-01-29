//
//  AnalogClockView.swift
//  SunTime
//
//  Created by Руслан Ольховка on 11.01.15.
//  Copyright (c) 2015 Руслан Ольховка. All rights reserved.
//

import UIKit

@IBDesignable class AnalogClockView: UIControl
{
//    @IBInspectable var enableGraduations = true

    @IBInspectable var faceColor: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    @IBInspectable var faceAlpha: CGFloat = 0.95

    @IBInspectable var borderColor: UIColor = UIColor.whiteColor()
    @IBInspectable var borderWidth: CGFloat = 3
    @IBInspectable var borderAlpha: CGFloat = 1.0
    
    @IBInspectable var digitEnable: Bool = true
    @IBInspectable var digitColor: UIColor = UIColor.whiteColor()
    @IBInspectable var digitFont: UIFont = UIFont(name: "HelveticaNeue-Thin", size: 17)!
    @IBInspectable var digitOffset: CGFloat = 0
    
    var graduationColor = UIColor.whiteColor()
    var graduationAlpha: CGFloat = 1.0
    var graduationWidth: CGFloat = 1.0
    var graduationLength: CGFloat = 5.0
    var graduationOffset: CGFloat = 10.0
    
    private var sec: Hand!
    @IBInspectable var secColor: UIColor = UIColor.redColor()
    @IBInspectable var secAlpha: CGFloat = 1;
    @IBInspectable var secWidth: CGFloat = 2;
    @IBInspectable var secRatio: CGFloat = 0.98;
    @IBInspectable var secOffside: CGFloat = 0;
    
    private var min: Hand!
    @IBInspectable var minColor: UIColor = UIColor.whiteColor()
    @IBInspectable var minAlpha: CGFloat = 1;
    @IBInspectable var minWidth: CGFloat = 4;
    @IBInspectable var minRatio: CGFloat = 0.77;
    @IBInspectable var minOffside: CGFloat = 0;
    
    private var hour: Hand!
    @IBInspectable var hourColor: UIColor = UIColor.whiteColor()
    @IBInspectable var hourAlpha: CGFloat = 1;
    @IBInspectable var hourWidth: CGFloat = 6;
    @IBInspectable var hourRatio: CGFloat = 0.5;
    @IBInspectable var hourOffside: CGFloat = 0;
    
    private let PI = CGFloat(M_PI)
    internal var dateOffset: NSTimeInterval = 0;
    internal var date = NSDate(timeIntervalSinceNow: 1)
    private let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clearColor()
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("onTimer"), userInfo: nil, repeats: true)
    }
    
    override func layoutSubviews() {
        let rect = self.bounds
        
        // hour hand
        if (self.hour == nil) {
            self.hour = Hand(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            self.hour.degree = -35
            self.hour.color = self.hourColor
            self.hour.length = self.hourRatio * rect.width / 2
            self.hour.width = self.hourWidth
            self.hour.offsetLength = self.hourOffside
            self.addSubview(self.hour)
        }
        else {
//            self.hour.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        }
        
        // min hand
        if self.min == nil {
            self.min = Hand(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            self.min.degree = 15
            self.min.color = self.minColor
            self.min.length = self.minRatio * rect.width / 2
            self.min.width = self.minWidth
            self.min.offsetLength = self.minOffside
            self.addSubview(self.min)
        }
        else {
//            self.min.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        }
        
        // sec hand
        if self.sec == nil {
            self.sec = Hand(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            self.sec.degree = 0
            self.sec.color = self.secColor
            self.sec.length = self.secRatio * rect.width / 2
            self.sec.width = self.secWidth
            self.sec.offsetLength = self.secOffside
//            self.sec.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
            self.addSubview(self.sec)
//            self.sec.layer.anchorPoint = CGPoint(x: 0, y: 0)
        }
        else {
            
//            self.sec.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        }
        
    }
    
    func onTimer()
    {
        self.date = NSDate(timeIntervalSinceNow: 1 + self.dateOffset)
        let components = self.calendar.components(
            NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit |
            NSCalendarUnit.SecondCalendarUnit,
            fromDate: date)

        self.sec.degree = CGFloat(components.second * 6)
        self.min.degree = CGFloat(components.minute * 6) + self.sec.degree / 60
        self.hour.degree = CGFloat(components.hour * 30) + self.min.degree / 12
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.sec.transform = CGAffineTransformMakeRotation(self.sec.degree * self.PI / 180)
            self.min.transform = CGAffineTransformMakeRotation(self.min.degree * self.PI / 180)
            self.hour.transform = CGAffineTransformMakeRotation(self.hour.degree * self.PI / 180)
            }, completion: nil)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        
        //  CLOCK'S FACE
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(ctx, rect)
        CGContextSetFillColorWithColor(ctx, self.faceColor.CGColor)
        CGContextSetAlpha(ctx, self.faceAlpha)
        CGContextFillPath(ctx)
        
        // CLOCK'S BORDER
        CGContextAddEllipseInRect(ctx, CGRectMake(rect.origin.x + self.borderWidth/2, rect.origin.y + self.borderWidth/2, rect.size.width - self.borderWidth, rect.size.height - self.borderWidth))
        CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor)
        CGContextSetAlpha(ctx, self.borderAlpha)
        CGContextSetLineWidth(ctx, self.borderWidth)
        CGContextStrokePath(ctx)
        
        // CLOCK'S GRADUATION
//        if (self.enableGraduations)
//        {
//            for i in 0...59 {
//                let P1 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset) / 2) * cos((6*i)*(M_PI/180)  - (M_PI/2))), (self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset) / 2) * sin((6*i)*(M_PI/180)  - (M_PI/2))));
//                CGPoint P2 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset - self.graduationLength) / 2) * cos((6*i)*(M_PI/180)  - (M_PI/2))), (self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset - self.graduationLength) / 2) * sin((6*i)*(M_PI/180)  - (M_PI/2))));
//                
//                CAShapeLayer  *shapeLayer = [CAShapeLayer layer];
//                UIBezierPath *path1 = [UIBezierPath bezierPath];
//                shapeLayer.path = path1.CGPath;
//                [path1 setLineWidth:self.graduationWidth];
//                [path1 moveToPoint:P1];
//                [path1 addLineToPoint:P2];
//                path1.lineCapStyle = kCGLineCapSquare;
//                [self.graduationColor set];
//                
//                [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.graduationAlpha];
//            }
//        }
        
        // DIGIT DRAWING
        if (self.digitEnable)
        {
            let center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
            let markingDistanceFromCenter = rect.size.width/2.0 - self.digitFont.lineHeight/4.0 - 15 + self.digitOffset;
            let offset: CGFloat = 4;
            for i in 0...11 {
                let hourNumber: NSString = "\(i+1)"
                let labelX = center.x + (markingDistanceFromCenter - self.digitFont.lineHeight/2.0) * cos((CGFloat(M_PI)/180) * (CGFloat(i) + offset) * 30 + CGFloat(M_PI)) + 5
                let labelY = center.y - (markingDistanceFromCenter - self.digitFont.lineHeight/2.0) * sin((CGFloat(M_PI)/180) * (CGFloat(i) + offset) * 30)
                hourNumber.drawInRect(CGRect(x: labelX - self.digitFont.lineHeight/2.0, y: labelY - self.digitFont.lineHeight/2.0, width: digitFont.lineHeight, height: digitFont.lineHeight), withAttributes: [NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont])
            }
        }
    }


}
