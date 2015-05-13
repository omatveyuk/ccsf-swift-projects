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
    
     
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    var searchTask: NSURLSessionDataTask?

    var today = NSDate()
    var days : [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var weekNumbers : [String] = ["First", "Second", "Third", "Fourth", "Fifth"]
    
    @IBOutlet weak var LabelLocation: UILabel!
    var lastLocation = CLLocation()
    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    func endEditingNow(){
        //activityIndicatorView.startAnimating()
        //delegate.locationManager.startUpdatingLocation()
        
        // delegate.locationManager.stopUpdatingLocation()
        //activityIndicatorView.stopAnimating()
        if let isAnimating = refreshActivityIndicator?.isAnimating() {
            println("Animating")
        }
        
    }
    
    func getCurrentLocationData() -> Void {
        // LocationManager.sharedInstance.autoUpdate = true
        LocationManager.sharedInstance.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            if (error == nil){
                LocationManager.sharedInstance.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude:longitude, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
                    if (error == nil){
                        if let x = reverseGecodeInfo?["formattedAddress"] as? NSString {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.LabelLocation.text = x as String
                                let now = NSDate()
                                self.debugLabel.text = "\(latitude) \(longitude) \(now)"
                                
                                
                                //Stop refresh animation
                                self.refreshActivityIndicator.stopAnimating()
                                self.refreshActivityIndicator.hidden = true
                                self.refreshButton.hidden = false
                            })
                        }
                    }else{
                        println(error)
                        let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error", preferredStyle: .Alert)
                        let okButton = UIAlertAction    (title: "OK", style: .Default, handler: nil)
                        networkIssueController.addAction(okButton)
                        
                        
                        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                        networkIssueController.addAction(cancelButton)
                            
                        self.presentViewController(networkIssueController, animated: true, completion: nil)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //Stop refresh animation
                            self.refreshActivityIndicator.stopAnimating()
                            self.refreshActivityIndicator.hidden = true
                            self.refreshButton.hidden = false
                        
                        })
                    }
                
                })
            }else{
                println(error)
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error", preferredStyle: .Alert)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    
    
    @IBAction func refresh() {
        getCurrentLocationData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addActor")
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem (title: "Refresh", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("endEditingNow"))
            
        refreshActivityIndicator.hidden = true
        
        getCurrentLocationData()

        
        
        
        let buttonEdit: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonEdit.frame = CGRectMake(0, 0, 20, 20)
        buttonEdit.setImage(UIImage(named:"refresh.png"), forState: UIControlState.Normal)
        buttonEdit.addTarget(self, action: Selector("endEditingNow"), forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        // self.navigationItem.rightBarButtonItem = rightBarButtonItemEdit
        self.navigationItem.setRightBarButtonItems([rightBarButtonItemEdit], animated: true)
        
        
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
        // self.initLocationManager()
        
        
    }
    
    lazy var delegate: AppDelegate = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        return delegate
        }()
    

    
    // Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        //delegate.locationManager = CLLocationManager()
        //delegate.locationManager.delegate = self
        //delegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //delegate.locationManager.requestAlwaysAuthorization()
    }
    
    // Location Manager Delegate stuff
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //delegate.locationManager.stopUpdatingLocation()
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
            // delegate.locationManager.startUpdatingLocation()
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

