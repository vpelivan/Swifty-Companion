//
//  SkillsViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/25/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SkillsViewCell: UITableViewCell {
    @IBOutlet weak var moreSkillsButton: UIButton!
    @IBOutlet weak var skillNameOne: UILabel!
    @IBOutlet weak var skillNameTwo: UILabel!
    @IBOutlet weak var skillNameThree: UILabel!
    @IBOutlet weak var levelOne: UILabel!
    @IBOutlet weak var levelTwo: UILabel!
    @IBOutlet weak var levelThree: UILabel!
    @IBOutlet weak var skillEtc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setBordersToButton() {
        moreSkillsButton.layer.borderWidth = 1.0
        moreSkillsButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
    }

}
