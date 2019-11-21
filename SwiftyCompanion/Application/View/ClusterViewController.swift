//
//  ClusterViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var row: Int = 1
    var place: Int = 1
    var location: String = "location"
    var cellId: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.location = String("e1r\(self.row)p\(self.place)")
        print(self.location)
    }

}

extension ClusterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 240
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyMacCell", for: indexPath)
        
        return cell
    }

}
