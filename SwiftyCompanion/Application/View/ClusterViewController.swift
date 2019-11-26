//
//  ClusterViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterViewController: UIViewController {

    var row: Int = 1
    var place: Int = 1
    var location: String = "location"
    var cellId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location = String("e1r\(self.row)p\(self.place)")
        print(self.location)
    }

    func CreateCluster() {
        
    }
}

