//
//  FillUpController.swift
//  SF Parking Helper
//
//  Created by misha birman1 on 5/12/15.
//  Copyright (c) 2015 misha birman. All rights reserved.
//

import UIKit



class FillUpHistoryViewController : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFillUp")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func addFillUp() {
        
        
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FillUpViewController") as! FillUpViewController
        
        // controller.delegate = self
        
        // self.presentViewController(controller, animated: true, completion: nil)
        //presentViewController(controller, animated: true, completion: nil)
        self.navigationController!.pushViewController(controller, animated: true)
        
    }

}