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
        static let PricePerGallon = "price_per_gallon"
        static let Timestamp = "timestamp"
    }
    
    var timestamp = NSDate()
    var totalPrice = 0.0 // :Double
    var totalMiles = 0.0 //:Double
    var pricePerGallon = 0.0
    
    init(dictionary: [String : AnyObject]) {
        totalPrice = dictionary[Keys.TotalPrice] as! Double
        totalMiles = dictionary[Keys.TotalMiles] as! Double
        pricePerGallon = dictionary[Keys.PricePerGallon] as! Double
        timestamp = dictionary[Keys.Timestamp] as! NSDate
    }
    
    init(tp:Double, tm:Double, pg:Double) {
        totalPrice = tp
        totalMiles = tm
        pricePerGallon = pg
        timestamp = NSDate()
    }
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(totalPrice, forKey: Keys.TotalPrice)
        // archiver.encodeInteger(id, forKey: Keys.ID)
        archiver.encodeObject(totalMiles, forKey: Keys.TotalMiles)
        archiver.encodeObject(pricePerGallon, forKey: Keys.PricePerGallon)
        archiver.encodeObject(timestamp, forKey:Keys.Timestamp)
    }
    
    
    required init(coder unarchiver: NSCoder) {
        super.init()
        
        totalMiles = unarchiver.decodeObjectForKey(Keys.TotalMiles) as! Double
        // id = unarchiver.decodeIntegerForKey(Keys.ID)
        totalPrice = unarchiver.decodeObjectForKey(Keys.TotalPrice) as! Double
        pricePerGallon = unarchiver.decodeObjectForKey(Keys.PricePerGallon) as! Double
        timestamp = unarchiver.decodeObjectForKey(Keys.Timestamp) as! NSDate
    }


}