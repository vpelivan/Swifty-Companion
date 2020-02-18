//
//  CurrentLevelViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/17/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class CurrentLevelViewCell: UITableViewCell {

    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet var checkmark: [UIImageView]!
    @IBOutlet var internship: [UIImageView]!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.cornerRadius = 5.0
    }
}
