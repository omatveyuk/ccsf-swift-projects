//
//  FillUpController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit

protocol FooTwoViewControllerDelegate{
    func myVCDidFinish(controller:FillUpViewController,text:FillUp)
}

class FillUpViewController : UIViewController{
    
    var delegate:FooTwoViewControllerDelegate? = nil
    
    @IBAction func Done(sender: UIButton) {
        
        println("Save")
        if (delegate != nil) {
            // delegate!.myVCDidFinish(self, text: "misha birman")
        }
    }
    var temp = FillUp(tp: 0.0, tm: 0.0, pg: 0.0)
    
    @IBOutlet weak var pricePerMile: UILabel!
    @IBOutlet weak var totalGallons: UILabel!
    @IBOutlet weak var pricePerGallon: UITextField!
    @IBOutlet weak var totalPrice: UITextField!
    @IBOutlet weak var totalMiles: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelFillUp")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveFillUp")
    }
    
    
    func saveFillUp(){
        
        temp.timestamp = NSDate()
        temp.totalMiles=Double((totalMiles.text as NSString).doubleValue)
        temp.totalPrice = Double((totalPrice.text as NSString).doubleValue)
        temp.pricePerGallon = Double((pricePerGallon.text as NSString).doubleValue)
        
        var c:String = String(format:"%.2f", (temp.totalPrice / temp.totalMiles))
        
        self.pricePerMile.text = c
        
        println("Price per mile is \(temp.totalPrice / temp.totalMiles)")
        //dismissViewControllerAnimated(true, completion: nil)
        
        println("Save")
        if (delegate != nil) {
            delegate!.myVCDidFinish(self, text: temp)
        }

    }
}


