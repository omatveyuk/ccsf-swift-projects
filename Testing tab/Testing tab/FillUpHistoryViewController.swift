//
//  FillUpController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit



class FillUpHistoryViewController : UIViewController, UITableViewDelegate,  FooTwoViewControllerDelegate{
    // var history = [FillUp]()
    
    @IBOutlet weak var Average: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFillUp")
        
    
        
        if let fillUpHistoryArray = NSKeyedUnarchiver.unarchiveObjectWithFile(delegate.actorArrayFile.path!) as? [FillUp] {
            delegate.history = fillUpHistoryArray
        }
        
        computeAverages()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    private func computeAverages (){
        // calculate averages
        var average = 0.0
        var count = delegate.history.count
        if count > 0 {
            for a in delegate.history{
                average = average + (a.totalPrice / a.totalMiles)
            }
            average = average / Double(count)
            self.Average.text = "$" + String(format:"%.2f", average)
        }
        else{
            let networkIssueController = UIAlertController(title: "Error", message: "No Data Available.", preferredStyle: .Alert)
            let okButton = UIAlertAction    (title: "Enter data", style: .Default, handler: { action -> Void in
                //Code for launching the camera goes here
                self.addFillUp()
            })
            networkIssueController.addAction(okButton)
            
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            networkIssueController.addAction(cancelButton)
            
            self.presentViewController(networkIssueController, animated: true, completion: nil)

        }
    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(delegate.history.count)
        return delegate.history.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let actor = delegate.history[indexPath.row]
        
        var idx = delegate.history[delegate.history.count - (indexPath.row+1)];
        var actor = idx
        
        let CellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ActorTableViewCell
        
        //cell.textLabel?.text = (actor.totalPrice / actor.totalMiles).description
        
        
        let myCalendar = NSCalendar.currentCalendar()
        let components = myCalendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: actor.timestamp)
        
        //let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        // let components = NSCalendar.currentCalendar().components(myComponents, fromDate: actor.timestamp)

        
        cell.timestampLabel.text = "Fillup date: \(components.month)-\(components.day)-\(components.year)"

        
        cell.namedLabel.text = "Miles: \(actor.totalMiles) \t Price per mile: $" + String(format:"%.2f", (actor.totalPrice / actor.totalMiles))
        cell.totalGallons.text = "Price: $\(actor.totalPrice) \t Gallons: " + String(format: "%.2f", (actor.totalPrice / actor.pricePerGallon))
        
        return cell
    }
    
    
    func myVCDidFinish(controller: FillUpViewController, text: FillUp?) {
        if let text = text {
            println("The Color is \(text.totalMiles)")
            // controller.navigationController?.popViewControllerAnimated(true)
            
            delegate.history.append(text)
            NSKeyedArchiver.archiveRootObject(delegate.history, toFile: delegate.actorArrayFile.path!)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.computeAverages()
                self.tableView.reloadData()
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    /*
    lazy var documentsDirectoryURL: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as! NSURL
        }()
    
    lazy var actorArrayFile: NSURL = {
        return self.documentsDirectoryURL.URLByAppendingPathComponent("DriveCostAnalyzerFile")
        }()
    
    var actorArrayURL: NSURL {
    let filename = "DriveCostAnalyzer"
    let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL

    return documentsDirectoryURL.URLByAppendingPathComponent(filename)
    }
*/

    func addFillUp() {


        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FillUpViewController") as! FillUpViewController
        
        controller.delegate = self
        
        self.presentViewController(controller, animated: true, completion: nil)
        //presentViewController(controller, animated: true, completion: nil)
        //self.navigationController!.pushViewController(controller, animated: true)
        
    }
    

    
    lazy var delegate: AppDelegate = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        return delegate
        }()


}