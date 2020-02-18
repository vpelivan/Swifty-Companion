//
//  NewCellController.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/14/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userCampus: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userPool: UILabel!
    @IBOutlet weak var userPoints: UILabel!
    @IBOutlet weak var userWallet: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
