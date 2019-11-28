//
//  PoolTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/28/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class PoolTableViewCell: UITableViewCell {

    @IBOutlet weak var poolDayName: UILabel!
    @IBOutlet weak var poolDayStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
