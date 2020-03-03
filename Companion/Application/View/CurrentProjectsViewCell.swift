//
//  CurrentProjectsViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/25/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class CurrentProjectsViewCell: UITableViewCell {
    @IBOutlet weak var allProjectsButton: UIButton!
    @IBOutlet weak var projectNameOne: UILabel!
    @IBOutlet weak var projectNameTwo: UILabel!
    @IBOutlet weak var projectNameThree: UILabel!
    @IBOutlet weak var projectNameEtcDots: UILabel!
    @IBOutlet weak var subView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBorderdersToButton()
        subView.layer.cornerRadius = 5.0
    }
    
    @IBAction func tapAllProjects(_ sender: UIButton) {
        
    }
    
    public func setBorderdersToButton() {
        allProjectsButton.layer.borderWidth = 1.0
        allProjectsButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
    }
}
