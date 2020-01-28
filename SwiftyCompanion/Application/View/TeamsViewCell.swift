//
//  TeamsViewCell.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 1/27/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class TeamsViewCell: UITableViewCell {

    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var closedAt: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var validated: UILabel!
    @IBOutlet weak var finalMark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TeamsViewCell {
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row: Int)
    {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        
        collectionView.reloadData()
    }
}
