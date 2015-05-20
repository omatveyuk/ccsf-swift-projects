//
//  History.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/16/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit
class HistoryController : UIViewController, UITableViewDelegate, FooTwoViewControllerDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Average: UILabel!
    //var history = [FillUp]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        //self.navItem.title = "Fillup history"
        //self.navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFillUp")
        
        //self.navBar.items[0] = self.navItem
        
        computeAverages()
        
        
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
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.history.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let actor = delegate.history[indexPath.row]
        let CellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ActorTableViewCell
        
        
        var idx = delegate.history[delegate.history.count - (indexPath.row+1)];
        var actor = idx
        
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
        println("The Color is \(text!.totalMiles)")
        // controller.navigationController?.popViewControllerAnimated(true)
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        self.delegate.history.append(text!)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.computeAverages()
        }
        
        NSKeyedArchiver.archiveRootObject(self.delegate.history, toFile: delegate.actorArrayFile.path!)
    }
    
    
    @IBAction func unwindFromFillupHistory(sender: UIStoryboardSegue) {
        
    }
    
    
    func addFillUp() {
        
        
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FillUpViewController") as! FillUpViewController
        
        controller.delegate = self
        
        self.presentViewController(controller, animated: true, completion: nil)
        //presentViewController(controller, animated: true, completion: nil)
        // self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    
    
    lazy var delegate: AppDelegate = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        return delegate
        }()
    

}
