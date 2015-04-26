//
//  ViewController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 4/24/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UIApplicationDelegate, CLLocationManagerDelegate {
    
    var searchTask: NSURLSessionDataTask?

    var today = NSDate()
    var days : [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    
    
    var lastLocation = CLLocation()
    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"

    
    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myCalendar = NSCalendar.currentCalendar() // (calendarIdentifier: NSCalendarIdentifierGregorian)
        
        //let myComponents = myCalendar!.components(NSCalendarUnit.WeekOfMonthCalendarUnit, fromDate: today)
        let myComponents = myCalendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfMonth | NSCalendarUnit.CalendarUnitWeekday, fromDate: today)
        
        let weekDay = myComponents.weekOfMonth
        
        // this can be computed as well
        println((myComponents.day - 1 ) / 7 + 1 )
        
        println(weekDay)
        Label.text = "Today is \(weekDay) \(days[myComponents.weekday-1]) of the Month"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.initLocationManager()
        
    }
    // Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
    }
    
    // Location Manager Delegate stuff
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
            
            let loc = "\(coord.latitude),\(coord.longitude)"
            // start here
            
            // Start a new one download
            let resource = BingLocationDB.Resources.SearchPerson
            let parameters = [BingLocationDB.Keys.ID : loc]
            
            BingLocationDB.sharedInstance().taskForResource(resource, parameters: parameters){ JSONResult, error  in
                
                // Handle the error case
                if let error = error {
                    println("Error searching for actors: \(error.localizedDescription)")
                    return
                }
                
                if let moviesDictionaries = JSONResult.valueForKey("resourceSets") as? [[String : AnyObject]] {
                
                
                }
                
                
                
            }

            
            // end here
            
            
            
            
            
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager!,  didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
}

