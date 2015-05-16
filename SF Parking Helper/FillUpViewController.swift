//
//  FillUpController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit

protocol FooTwoViewControllerDelegate{
    func myVCDidFinish(controller:FillUpViewController,text:FillUp?)
}

class FillUpViewController : UIViewController, UITextFieldDelegate{
    
    var delegate:FooTwoViewControllerDelegate? = nil
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBAction func PricePerGallonEditing(sender: UITextField) {
        println("PricePerGallonEditing")
        //numbers = Array(arrayLiteral: sender.text)
    }
    
    @IBAction func TotalPricePaidEditing(sender: UITextField) {
        //numbers = Array(arrayLiteral: sender.text)

    }
    
    
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
    
    
    // var numbers: [[String]] = [[]]
    var numbers: [[String]] = [[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navItem.title = "Fillup details"
        
        self.navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveFillUp")
        
        
        self.navBar.items[0] = self.navItem

        // self.navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "cancelFillUp")
        
        // self.navBar.items[1] = self.navItem
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelFillUp")
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "cancelFillUp")
        
        pricePerGallon.tag = 0
        totalPrice.tag = 1
        
        pricePerGallon.delegate = self
        totalPrice.delegate = self
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        
        if (textField.tag == 0 || textField.tag == 1){
            
            //$0.00
            //$0.02
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "1234567890").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            result = replacementStringIsLegal;
            
            if (replacementStringIsLegal)
            {
                if (string == "" && numbers[textField.tag].count > 0)
                {
                    numbers[textField.tag].removeLast()
                }
                if (string != "")
                {
                    numbers[textField.tag].append(string)
                }
                
                let c = numbers[textField.tag].count
                
                if (c == 0)
                {
                    textField.text = "$0.00"
                }
                if (c == 1)
                {
                    textField.text = "$0.0" + numbers[textField.tag][0]
                }
                
                if (c == 2)
                {
                    textField.text = "$0." + numbers[textField.tag][0] + numbers[textField.tag][1]
                }
                
                if (c > 2)
                {
                    var t:String = "";
                    t = "$"
                    for i in 0..<numbers[textField.tag].count{
                        if (i == numbers[textField.tag].count - 2)
                        {
                            t = t + "."
                        }
                        println(numbers[textField.tag][i])
                        t = t + numbers[textField.tag][i]
                    }
                    textField.text = t;
                }
                
            }
            result = false;
        }
        return result
    }
    
    
    
    
    @IBAction func cancelFillUp(sender : UIBarButtonItem) {
        if (delegate != nil) {
            delegate!.myVCDidFinish(self, text: nil)
        }
    }
    
    func saveFillUp(){
        
        temp.timestamp = NSDate()
        temp.totalMiles=Double((totalMiles.text as NSString).doubleValue)
        temp.totalPrice = Double((dropFirst(totalPrice.text) as NSString).doubleValue)
        temp.pricePerGallon = Double((dropFirst(pricePerGallon.text) as NSString).doubleValue)
        
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


