//
//  SunTime.swift
//  SunTime
//
//  Created by Руслан Ольховка on 06.01.15.
//  Copyright (c) 2015 Руслан Ольховка. All rights reserved.
//

import UIKit

class SunTime: NSObject {
    
    let zenith = 90 + 50/60.0
    var latitude = 55.998745
    var longitude = 92.912903
    
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    func stringFromTime(rising: Bool) -> String
    {
        return stringFromDate(self.dateFromTime(rising))
    }
    
    func dateFromTime(rising: Bool) -> NSDate
    {
        let localTime = self.calculate(rising)
        let components = self.calendar.components(
            NSCalendarUnit.YearCalendarUnit |
                NSCalendarUnit.MonthCalendarUnit |
                NSCalendarUnit.DayCalendarUnit |
                NSCalendarUnit.TimeZoneCalendarUnit,
            fromDate: NSDate())
        
        var resultDate = self.calendar.dateFromComponents(components)!
        resultDate = resultDate.dateByAddingTimeInterval(localTime * 3600)
        
        return resultDate
    }
    
    func stringFromDate(date:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        return dateFormatter.stringFromDate(date)
    }
    
    private func calculate(rising: Bool) -> Double
    {
        // 1
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "D"
        let N:Int = dateFormatter.stringFromDate(NSDate()).toInt()!
        
        // 2
        
        let lngHour = longitude / 15
        var t:Double
        if rising
        {
            t = Double(N) + ((6 - lngHour) / 24)
        }
        else
        {
            t = Double(N) + ((18 - lngHour) / 24)
        }
        
        // 3
        
        let M = (0.9856 * t) - 3.289
        
        // 4
        
        var L = M + (1.916 * sin(deg2rad(M))) + (0.020 * sin(deg2rad(2 * M))) + 282.634
        L %= 360
        
        // 5a
        
        var RA = rad2deg(atan(0.91764 * tan(deg2rad(L))))
        
        // 5b
        
        let Lquadrant = floor(L / 90) * 90
        let RAquadrant = floor(RA / 90) * 90
        RA += (Lquadrant - RAquadrant)
        
        // 5c
        
        RA /= 15
        
        //6
        
        let sinDec = 0.39782 * sin(deg2rad(L))
        let cosDec = cos(asin(sinDec))
        
        // 7a
        
        let cosH = (cos(deg2rad(zenith)) - (sinDec * sin(deg2rad(latitude)))) / (cosDec * cos(deg2rad(latitude)))
        if cosH > 1
        {
            "sun never rises"
        }
        if cosH < -1
        {
            "sun never sets"
        }
        
        // 7b
        
        var H:Double
        if rising
        {
            H = 360 - rad2deg(acos(cosH))
        }
        else
        {
            H = rad2deg(acos(cosH))
        }
        H /= 15
        
        // 8
        
        let T = H + RA - (0.06571 * t) - 6.622
        
        // 9
        
        let UT = T - lngHour
        
        // 10

        let components = self.calendar.components(NSCalendarUnit.TimeZoneCalendarUnit, fromDate: NSDate())
        let localOffset = Double(components.timeZone!.secondsFromGMT) / 3600
        let localTime = UT + localOffset
        
        return localTime % 24
    }
    
    private func rad2deg(value: Double) -> Double
    {
        return value * 180 / M_PI
    }
    
    private func deg2rad(value: Double) -> Double
    {
        return value * M_PI / 180
    }

}