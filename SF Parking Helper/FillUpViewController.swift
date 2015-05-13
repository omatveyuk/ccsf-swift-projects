//
//  FillUpController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit


class FillUpViewController : UIViewController{
    
    var temp = FillUp()
    
    @IBOutlet weak var totalPrice: UITextField!
    @IBOutlet weak var totalMiles: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelFillUp")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveFillUp")
    }
    
    
    func saveFillUp(){
        
        
        
        temp.totalMiles=Double((totalMiles.text as NSString).doubleValue)
        temp.totalPrice = Double((totalPrice.text as NSString).doubleValue)
        
        println("Price per mile is \(temp.totalPrice! / temp.totalMiles!)")
    }
}


