//
//  ViewController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 4/24/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myCalendar = NSCalendar.currentCalendar() // (calendarIdentifier: NSCalendarIdentifierGregorian)
        
        //let myComponents = myCalendar!.components(NSCalendarUnit.WeekOfMonthCalendarUnit, fromDate: today)
        let myComponents = myCalendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfMonth, fromDate: today)
        
        let weekDay = myComponents.weekOfMonth
        
        // this can be computed as well
        println((myComponents.day - 1 ) / 7 + 1 )
        
        println(weekDay)
        println(myComponents.hour)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

