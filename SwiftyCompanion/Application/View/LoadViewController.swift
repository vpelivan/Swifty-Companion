//
//  LoadViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/26/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activityIndicator.stopAnimating()
    }
}
