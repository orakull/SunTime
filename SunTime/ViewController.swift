//
//  ViewController.swift
//  SunTime
//
//  Created by Руслан Ольховка on 20.12.14.
//  Copyright (c) 2014 Руслан Ольховка. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var sunRiseLbl: UILabel!
    @IBOutlet weak var sunSetLbl: UILabel!
    @IBOutlet weak var midTimeLbl: UILabel!
    @IBOutlet weak var curTimeLbl: UILabel!
    @IBOutlet weak var analogClock: AnalogClockView!

    @IBAction func onClockClick(sender: AnyObject) {
        println(analogClock.dateOffset)
        if analogClock.dateOffset == 0 {
            analogClock.dateOffset = self.offset
        } else {
            analogClock.dateOffset = 0
        }
    }
    
    var locationManager: CLLocationManager!
    let sunTime = SunTime()
    var offset: NSTimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.startMonitoringSignificantLocationChanges()
//        self.locationManager.startUpdatingLocation()
        
        switch (CLLocationManager.authorizationStatus()) {
        case CLAuthorizationStatus.NotDetermined:
            println("NotDetermined")
            break;
        case CLAuthorizationStatus.Restricted:
            println("Restricted")
            break;
        case CLAuthorizationStatus.Denied:
            println("Denied")
            break;
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            println("AuthorizedWhenInUse")
            break;
        default:
            break;
        }
        
        // TODO: убрать
        // если не срабатывает определение позиции, то делаем все вручную
        self.setActualTimeInfo()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
//        self.locationManager.stopMonitoringSignificantLocationChanges();
        
        let location: CLLocation = locations.last as CLLocation
        let eventDate = location.timestamp
        let howRecent = eventDate.timeIntervalSinceNow

        self.latitudeLbl.text = location.coordinate.latitude.description
        self.longitudeLbl.text = location.coordinate.longitude.description
        
        self.sunTime.latitude = location.coordinate.latitude
        self.sunTime.longitude = location.coordinate.longitude
        
        self.setActualTimeInfo()
    }
    
    func setActualTimeInfo()
    {
        self.sunRiseLbl.text = "Восход " + self.sunTime.stringFromTime(true)
        self.sunSetLbl.text = "Закат " + self.sunTime.stringFromTime(false)
        
        let riseDate = self.sunTime.dateFromTime(true)
        let setDate = self.sunTime.dateFromTime(false)
        let midDate = riseDate.dateByAddingTimeInterval(setDate.timeIntervalSinceDate(riseDate) / 2)
        self.midTimeLbl.text = "Полдень " + self.sunTime.stringFromDate(midDate)
        
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.TimeZoneCalendarUnit, fromDate: NSDate())
        var realMidDate = calendar.dateFromComponents(components)!
        realMidDate = realMidDate.dateByAddingTimeInterval(12 * 3600) // 12:00
        self.offset = -midDate.timeIntervalSinceDate(realMidDate)
        let sunDate = NSDate().dateByAddingTimeInterval(offset)
        self.curTimeLbl.text = "Солнечное время " + self.sunTime.stringFromDate(sunDate)
        
        self.analogClock.dateOffset = offset
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        analogClock.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

