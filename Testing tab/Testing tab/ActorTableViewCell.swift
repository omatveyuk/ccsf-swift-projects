//
//  ActorTableViewCell.swift
//  FavoriteActors
//
//  Created by Jason on 2/2/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit

class ActorTableViewCell : TaskCancelingTableViewCell {
    
    //@IBOutlet var frameImageView: UIImageView!
    //@IBOutlet var actorImageView: UIImageView!

    @IBOutlet weak var namedLabel: UILabel!
    @IBOutlet weak var totalGallons: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var totalMiles: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
}