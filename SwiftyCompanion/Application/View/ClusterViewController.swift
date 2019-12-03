//
//  ClusterViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterViewController: UIViewController {

    var row: Int = 1
    var place: Int = 1
    var location: String = "location"
    var cellId: Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.location = String("e1r\(self.row)p\(self.place)")
        print(self.location)
    }

    func CreateCluster() {
        
    }
}

extension ClusterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "macCell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel.textColor = UIColor.black
        cell.textLabel.text = "\(indexPath.section)&&\(indexPath.row)"
        return cell
    }
}
