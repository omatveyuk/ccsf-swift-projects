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
        var t = FillUp()
        t.totalMiles = 1000
        t.totalPrice = 200
        self.history.append(t)
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFillUp")

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
        
        cell.textLabel?.text = (actor.totalPrice! / actor.totalMiles!).description
        
        
        return cell
    }
    
    
    func myVCDidFinish(controller: FillUpViewController, text: FillUp) {
        println("The Color is \(text.totalMiles)")
        controller.navigationController?.popViewControllerAnimated(true)
        
        self.history.append(text)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }

    }
    
    func addFillUp() {
        
        
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FillUpViewController") as! FillUpViewController
        
        controller.delegate = self
        
        // self.presentViewController(controller, animated: true, completion: nil)
        //presentViewController(controller, animated: true, completion: nil)
        self.navigationController!.pushViewController(controller, animated: true)
        
    }

}