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
    
    var weekNumbers : [String] = ["First", "Second", "Third", "Fourth", "Fifth"]
    
    
    
    var lastLocation = CLLocation()
    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"

    
    @IBOutlet weak var LabelLocation: UILabel!
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
        Label.text = "Today is \(weekNumbers[weekDay-1]) \(days[myComponents.weekday-1]) of the Month"
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
            // lasteJson()
            
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
                
                if let books = JSONResult["resourceSets"] as? Array<Dictionary<String, AnyObject>> {
                    if books.count > 0{
                        if let books1 = books[0]["resources"] as? Array<Dictionary<String, AnyObject>>{
                            if books1.count > 0 {
                                if let books2 = books1[0]["name"] as? String {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.LabelLocation.text = books2
                                    }
                                }
                                
                            }
                        }
                    }
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
    
    
    func lasteJson(){
        let urlPath = "http://dev.virtualearth.net/REST/v1/Locations/37.785834,-122.406417?key=Aoz5aNfanNaMxDdBD87NokA3PUMtrCcG-sxAZIxsCaKaE7oqrHaisGbXNBYMiNw2&o=json"
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        
        var questionsArray=[Question]()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            else {
                var err: NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                
                
                
                if err != nil {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                else {
                    let books = jsonResult["resourceSets"] as! Array<Dictionary<String, AnyObject>>
                    let books1 = books[0]["resources"] as! Array<Dictionary<String, AnyObject>>
                    let books2 = books1[0]["name"] as! String
                    
                    
                    if let questions = jsonResult["resourceSets"] as? [[String:AnyObject]]{
                        // let q2 = questions["resources"]
                        println(questions)
                    }
                    
                    
                    }
                    
                
            }
        })
        
        task.resume()
        
    }
}

