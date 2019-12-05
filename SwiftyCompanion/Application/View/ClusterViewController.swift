//
//  ClusterViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterViewController: UIViewController {

    var ClusterLoggedUsers: [ClusterUsers?] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.isScrollEnabled = true
        getClusterInfo()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ClusterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 23
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return CreateCluster(indexPath: indexPath)
    }
    
    func CreateCluster(indexPath: IndexPath) -> UICollectionViewCell {
        let loggedMacCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoggedMacCell", for: indexPath) as! LoggedMacCell
        let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelMacCell
        let emptyMacCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyMacCell", for: indexPath)
        let pathCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pathCell", for: indexPath)
        let wallsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallsCell", for: indexPath)
//        var location: String?
//        var row: Int = 1
//        var place: Int = 1
//        let totalPlacesNum = 264
//        for i in 0..<totalPlacesNum
//        {
//
//            row += 1;
//            place += 1;
//        }
//    }
        let pos = indexPath.item
        var mac = pos + 1
        print(pos)
        let row = 12 - indexPath.section
        var location = String("e1r\(row)p\(pos)")
        print(location)
//        return UICollectionViewCell()
        if pos == 0 || pos == 22 {
            labelCell.label.text = "r\(row)"
            return labelCell
        }
        
        if (pos == 7 || pos == 18) || (row == 12 && (pos >= 3 && pos <= 19)
        || ((row == 11 || row == 10) && (pos >= 5 && pos <= 14))) {
            return pathCell
        }
        
        if (row != 12 && row % 3 == 0 && (pos == 7 || pos == 11 || pos == 17)) {
            return wallsCell
        }
        
        return emptyMacCell
    }
}

extension ClusterViewController {
    func getClusterInfo() {
        let token = AuthUser.shared.tokenJson?["access_token"] as! String
        let intraURL = AuthUser.shared.intraURL
        let url = NSURL(string: "\(intraURL)/v2/campus/8/locations")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                guard let data = data else { return }
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
                print("Campus users: \(json ?? [])")
                self.ClusterLoggedUsers = try JSONDecoder().decode([ClusterUsers?].self, from: data)
                print(self.ClusterLoggedUsers)
                self.fillClusterInfo()
            }
            catch let error {
                return print("Another error:\(error)")
            }
        }.resume()
    }
    
    func fillClusterInfo() {
    }
}
