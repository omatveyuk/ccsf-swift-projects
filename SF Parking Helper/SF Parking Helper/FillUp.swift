//
//  FillUp.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import Foundation

class FillUp : NSObject, NSCoding{
    
    struct Keys {
        static let TotalMiles = "total_miles"
        static let TotalPrice = "total_price"
    }
    
    
    var totalPrice = 0.0 // :Double
    var totalMiles = 0.0 //:Double
    
    init(dictionary: [String : AnyObject]) {
        totalPrice = dictionary[Keys.TotalPrice] as! Double
        totalMiles = dictionary[Keys.TotalMiles] as! Double
    }
    
    init(x:Double, y:Double) {
        totalPrice = x
        totalMiles = y
    }
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(totalPrice, forKey: Keys.TotalPrice)
        // archiver.encodeInteger(id, forKey: Keys.ID)
        archiver.encodeObject(totalMiles, forKey: Keys.TotalMiles)
    }
    
    
    required init(coder unarchiver: NSCoder) {
        super.init()
        
        totalMiles = unarchiver.decodeObjectForKey(Keys.TotalMiles) as! Double
        // id = unarchiver.decodeIntegerForKey(Keys.ID)
        totalPrice = unarchiver.decodeObjectForKey(Keys.TotalPrice) as! Double
    }


}