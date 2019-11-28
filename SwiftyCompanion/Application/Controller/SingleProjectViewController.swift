//
//  SingleProjectViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/22/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SingleProjectViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var of100Label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var colorCyan = UIColor(red: 82.0/255.0, green: 183.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    var colorRed = UIColor(red: 223.0/255.0, green: 134.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    var projectInfo: Projects!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(projectInfo!)
        navigationItem.title = projectInfo.project?.name
        fetchProjectInfo()
        // Do any additional setup after loading the view.
    }

    func fetchProjectInfo() {
        if projectInfo.status == "in_progress" {
            statusLabel.text = "subscribed"
            markLabel.isHidden = true
            of100Label.isHidden = true
            imageView.isHidden = false
        }
//        markLabel.text = String(projectInfo.final_mark)
    }

}
