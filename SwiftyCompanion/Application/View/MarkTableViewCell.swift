//
//  MarkTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/26/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class MarkTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var of100Label: UILabel!
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var projectType: UILabel!
    @IBOutlet weak var correctionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkboxImage.isHidden = true
    }
}
