//
//  SingleProjectViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/22/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SingleProjectViewController: UIViewController {
    
    var projectInfo: Projects!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = projectInfo.project?.slug
        // Do any additional setup after loading the view.
    }


}
