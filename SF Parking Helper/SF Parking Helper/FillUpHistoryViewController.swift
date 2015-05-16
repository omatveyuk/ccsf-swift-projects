//
//  FillUpController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit



class FillUpHistoryViewController : UITableViewController, FooTwoViewControllerDelegate{
    var history = [FillUp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFillUp")
        
        if let fillUpHistoryArray = NSKeyedUnarchiver.unarchiveObjectWithFile(actorArrayFile.path!) as? [FillUp] {
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let actor = history[indexPath.row]
        let CellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ActorTableViewCell
        
        //cell.textLabel?.text = (actor.totalPrice / actor.totalMiles).description
        
        
        let myCalendar = NSCalendar.currentCalendar()
        let components = myCalendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: actor.timestamp)
        
        //let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        // let components = NSCalendar.currentCalendar().components(myComponents, fromDate: actor.timestamp)

        
        cell.timestampLabel.text = "Fillup date: \(components.month)-\(components.day)-\(components.year)"

        
        cell.namedLabel.text = "Miles: \(actor.totalMiles) \t Price per mile: $" + String(format:"%.1f", (actor.totalPrice / actor.totalMiles))
        cell.totalGallons.text = "Price: $\(actor.totalPrice) \t Gallons: " + String(format: "%.2f", (actor.totalPrice / actor.pricePerGallon))
        
        return cell
    }
    
    
    func myVCDidFinish(controller: FillUpViewController, text: FillUp?) {
        println("The Color is \(text!.totalMiles)")
        controller.navigationController?.popViewControllerAnimated(true)
        
        self.history.append(text!)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }

        NSKeyedArchiver.archiveRootObject(self.history, toFile: actorArrayFile.path!)
    }
    
    
    lazy var documentsDirectoryURL: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as! NSURL
        }()
    
    lazy var actorArrayFile: NSURL = {
        return self.documentsDirectoryURL.URLByAppendingPathComponent("actorsFile")
        }()
    

    
    func addFillUp() {
        
        
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FillUpViewController") as! FillUpViewController
        
        controller.delegate = self
        
        // self.presentViewController(controller, animated: true, completion: nil)
        //presentViewController(controller, animated: true, completion: nil)
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    var actorArrayURL: NSURL {
        let filename = "favoriteActorsArray"
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        
        return documentsDirectoryURL.URLByAppendingPathComponent(filename)
    }
    
    
    lazy var delegate: AppDelegate = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        return delegate
        }()


}