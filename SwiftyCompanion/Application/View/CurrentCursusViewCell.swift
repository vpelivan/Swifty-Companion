//
//  CurrentCursusViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/17/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class CurrentCursusViewCell: UITableViewCell {

    @IBOutlet weak var changeCursusButton: UIButton!
    @IBOutlet weak var cursusName: UILabel!
    @IBOutlet weak var cursusGrade: UILabel!
    @IBOutlet weak var cursusCoalition: UILabel!
    @IBOutlet weak var cursusStarted: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBordersToButton()
        subView.layer.cornerRadius = 5.0
    }
    
    @IBAction func tapChangeCursus(_ sender: UIButton) {
        
    }
    
    func setBordersToButton() {
           changeCursusButton.layer.borderWidth = 1.0
           changeCursusButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
       }

}
