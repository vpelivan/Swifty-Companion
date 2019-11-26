//
//  EventTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/26/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateNumberLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var howLongLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var eventType: String = ""
    var colorCyan = UIColor(red: 82.0/255.0, green: 183.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    var colorRed = UIColor(red: 223.0/255.0, green: 134.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.borderWidth = 1.0
        getColor()
    }
    
    func getColor() {
        if eventType == "exam" {
            setColor(color: self.colorRed)
        } else {
            setColor(color: self.colorCyan)
        }
    }
    
    func setColor(color: UIColor) {
        cellView.layer.borderColor = color.cgColor
        dateView.layer.backgroundColor = color.cgColor
        eventNameLabel.textColor = color
        eventStatusLabel.textColor = color
        whenLabel.textColor = color
        howLongLabel.textColor = color
        locationLabel.textColor = color
    }
}
