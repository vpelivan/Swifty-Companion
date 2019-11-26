//
//  SkillsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/20/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillLevelLabel: UILabel!
    @IBOutlet weak var skillProgressBar: UIProgressView!
    
    override func prepareForReuse() {
        
    }
}
