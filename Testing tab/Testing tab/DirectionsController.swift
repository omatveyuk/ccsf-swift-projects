//
//  DirectionsController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/16/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit

class DirectionsController :UIViewController {

    
    @IBOutlet weak var totalCost: UILabel!
    
    @IBOutlet weak var distanceBetweenPoints: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var source: UITextField!
    
    @IBOutlet weak var destination: UITextField!
    
    
    
    //var history = [FillUp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        if let fillUpHistoryArray = NSKeyedUnarchiver.unarchiveObjectWithFile(delegate.actorArrayFile.path!) as? [FillUp] {
            delegate.history = fillUpHistoryArray
        }
    }
    
    
    lazy var delegate: AppDelegate = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        return delegate
        }()

        
    @IBAction func getTripCost(sender: UIButton) {
        println("PricePerGallonEditing")
    
        
        // http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=413+los+Palmos+drive+san+francisco%2Cca&wp.1=728+elm+street+san+carlos%2Cca&avoid=minimizeTolls&key=Aoz5aNfanNaMxDdBD87NokA3PUMtrCcG-sxAZIxsCaKaE7oqrHaisGbXNBYMiNw2
    
        let start = self.source.text
        let end = self.destination.text
        
        // Start a new one download
        let resource = BingLocationDB.Resources.GetDirections //.SearchPerson
        // let parameters = [BingLocationDB.Keys.ID : loc]
        let parameters = [BingLocationDB.Keys.WAYPOINT0 : start, BingLocationDB.Keys.WAYPOINT1 : end]
        
        
        let latestFillUp = self.delegate.history[self.delegate.history.count-1] as FillUp
        let pricePerMile = latestFillUp.totalPrice / latestFillUp.totalMiles
        
        BingLocationDB.sharedInstance().taskForResource(resource, parameters: parameters){ JSONResult, error  in
            
            // Handle the error case
            if let error = error {
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error", preferredStyle: .Alert)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                return
            }
            
            if let books = JSONResult["resourceSets"] as? Array<Dictionary<String, AnyObject>> {
                if books.count > 0{
                    if let books1 = books[0]["resources"] as? Array<Dictionary<String, AnyObject>>{
                        if books1.count > 0 {
                            if let books2 = books1[0]["travelDistance"] as? Double{
                                println(books2)
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.distanceBetweenPoints.text = "Total trip distance: " + String(format:"%.2f", books2) + " miles"
                                    self.totalCost.text = "Total trip cost: $" + String(format:"%.2f", (books2 * pricePerMile))
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
