//
//  ProfileViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/25/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit
import Foundation

class ProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileLoginLabel: UILabel!
    @IBOutlet weak var profileCampusLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profilePhoneLabel: UILabel!
    @IBOutlet weak var profileCursusLabel: UILabel!
    @IBOutlet weak var changeCursusButton: UIButton!
    @IBOutlet weak var profileLocationLabel: UILabel!
    @IBOutlet weak var profileLevelLabel: UILabel!
    @IBOutlet weak var profileProgressBar: UIProgressView!
    @IBOutlet weak var profileCoalitionLabel: UILabel!
    @IBOutlet weak var profileWalletLabel: UILabel!
    @IBOutlet weak var profileGradeLabel: UILabel!
    @IBOutlet weak var profileCorrectionLabel: UILabel!
    @IBOutlet weak var profileExamsLabel: UILabel!
    @IBOutlet weak var profileInternLabel: UILabel!
    @IBOutlet weak var profilePoolOfLablel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileChangeButton: UIButton!
    
    func getButtonBorder() {
        profileChangeButton.layer.borderWidth = 1.0
        profileChangeButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
    }
}
