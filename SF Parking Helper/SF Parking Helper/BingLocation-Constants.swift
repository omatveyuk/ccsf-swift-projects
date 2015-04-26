//
//  BingLocation-Constants.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 4/25/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import Foundation

extension BingLocationDB {
    struct Constants {
    
    // MARK: - URLs
    static let ApiKey = "Aoz5aNfanNaMxDdBD87NokA3PUMtrCcG-sxAZIxsCaKaE7oqrHaisGbXNBYMiNw2"
    static let BaseUrl = "http://dev.virtualearth.net/REST/v1/"
    }
    
    struct Keys {
        static let ID = "id"
        static let ErrorStatusMessage = "status_message"
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
    }
    
    
    struct Resources {
        
        // MARK: - Movies
        static let MovieID = "movie/:id";
        static let SearchPerson = "Locations/:id";
    }
}