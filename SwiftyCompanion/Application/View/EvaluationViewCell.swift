//
//  EvaluationViewCell.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/23/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class EvaluationViewCell: UITableViewCell {
    @IBOutlet weak var willEvaluate: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func viewProfile(_ sender: UIButton) {
        
    }
}
