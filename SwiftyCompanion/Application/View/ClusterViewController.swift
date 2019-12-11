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
    var clusterDict: [String : ClusterUsers?] = [:]
    var pictureDict: [String : UIImage?] = [:]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userViewPicture: UIImageView!
    @IBOutlet weak var userViewName: UILabel!
    @IBOutlet weak var userViewLocation: UILabel!
    @IBOutlet weak var userViewButton: UIButton!
    @IBOutlet weak var userViewBeginSess: UILabel!
    @IBOutlet weak var userViewSessTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.isScrollEnabled = true
        getClusterInfo(num: 1) {
            self.getClusterInfo(num: 2) {
                self.getClusterInfo(num: 3) {
                        DispatchQueue.main.async {
                            self.collectionView.delegate = self
                            self.collectionView.dataSource = self
//                            self.collectionView.reloadData()
                            self.navigationController?.navigationBar.topItem?.title = "\(self.clusterDict.count ) users logged in Cluster"
                        }
                }
            }
        }
        
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.reloadData()
    }
    @IBAction func closeButton(_ sender: Any) {
        userView.isHidden = true
    }
    @IBAction func tapRefresh(_ sender: UIBarButtonItem) {
//        for i in 1...3 {
//            print("i = ", i)
//            getClusterInfo(num: i) {
//
//                }
//            }
//            userView.isHidden = true
//        }
    }
}

extension ClusterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return CreateCluster(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pos = indexPath.item
        let row = 12 - indexPath.section
        let location = getLocation(pos: pos, row: row)
        
        if clusterDict["\(location)"] != nil {
            self.userView.isHidden = false
            let login = clusterDict["\(location)"]??.user?.login
            self.userViewPicture.image = pictureDict["\(location)"] as? UIImage
//            if let url = URL(string: "https://cdn.intra.42.fr/users/\(login ?? "").jpg") {
//                let session = URLSession.shared
//                session.dataTask(with: url) {(data, response, error) in
//                    DispatchQueue.main.async {
//                        if let data = data, let image = UIImage(data: data) {
//                        }
//                    }
//                }.resume()
//            }
            self.userViewButton.setTitle(login, for: .normal)
            self.userViewLocation.text = location
//            let time = self.clusterDict["\(location)"]??.begin_at!
//            let begin = String(time!.prefix(16)).replacingOccurrences(of: ".", with: " ")
            print(self.clusterDict["\(location)"]??.begin_at ?? "")
            var begin = String(self.clusterDict["\(location)"]??.begin_at ?? "")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            begin = String(begin.prefix(16)).replacingOccurrences(of: "T", with: " ")
            let beginGMT = dateFormatter.date(from: begin)!
            begin = dateFormatter.string(from: beginGMT.addingTimeInterval(7200))
            let end = dateFormatter.string(from: Date())
            let beginDate = dateFormatter.date(from: begin)!
            let endDate = dateFormatter.date(from: end)!
            let diffInHours = Calendar.current.dateComponents([.hour], from: beginDate, to: endDate).hour
            self.userViewBeginSess.text = "Began At:\n\(begin)"
            self.userViewSessTime.text = "Session Time:\n\(diffInHours ?? 0) hour(s)"
        }
        
    }
    func CreateCluster(indexPath: IndexPath) -> UICollectionViewCell {
        let pos = indexPath.item
        let row = 12 - indexPath.section
        let location = getLocation(pos: pos, row: row)
        
        if pos == 0 || pos == 21 {
            let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelMacCell
            labelCell.label.text = "r\(row)"
            return labelCell
        }
        
        else if (pos == 6 || pos == 17) || (row == 12 && (pos >= 3 && pos <= 18)
        || ((row == 11 || row == 10) && (pos >= 5 && pos <= 13))) {
            let pathCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pathCell", for: indexPath)
            return pathCell
        }
        
        else if (row != 12 && row % 3 == 0 && (pos == 6 || pos == 10 || pos == 16)) {
            let wallsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallsCell", for: indexPath)
            return wallsCell
        }
            
        else if clusterDict["\(location)"] != nil {
            let loggedMacCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoggedMacCell", for: indexPath) as! LoggedMacCell
            if let login = clusterDict["\(location)"]??.user?.login {
                loggedMacCell.textLabel.text = login
                
                if self.pictureDict[location] == nil {
                    guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login).jpg") else { return loggedMacCell}
                    let session = URLSession.shared
                    session.dataTask(with: url) {(data, response, error) in
                        DispatchQueue.main.async {
                            if let data = data, let image = UIImage(data: data) {
                                self.pictureDict[location] = image
                                loggedMacCell.imageView.image = image
                            }
                        }
                        }.resume()
                } else {
                    loggedMacCell.imageView.image = pictureDict["\(location)"] as? UIImage
                }

                
                
//                guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login).jpg") else { print("fail"); return loggedMacCell}
//                let session = URLSession.shared
//                session.dataTask(with: url) {(data, response, error) in
//                    DispatchQueue.main.async {
//                        if let data = data, let image = UIImage(data: data) {
//                            loggedMacCell.imageView.image = image
//                        }
//                    }
//                    }.resume()
            }
            return loggedMacCell
        }
        
        else {
            let emptyMacCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyMacCell", for: indexPath) as! EmptyMacCellController
            emptyMacCell.locationLabel.text = location
            return emptyMacCell
        }
        
    }
    
    func getLocation(pos: Int, row: Int) -> String {
        if (row >= 1 && row <= 9) && row % 3 != 0 {
            if (pos >= 1 && pos <= 5) {
                return  String("e1r\(row)p\(pos)")
            }
            else if (pos >= 7 && pos <= 16) {
                return  String("e1r\(row)p\(pos - 1)")
            }
            else if (pos >= 18 && pos <= 20) {
                return  String("e1r\(row)p\(pos - 2)")
            }
        } else if (row >= 1 && row <= 9) && row % 3 == 0 {
            if (pos >= 1 && pos <= 5) {
                return  String("e1r\(row)p\(pos)")
            }
            else if (pos >= 7 && pos <= 9) {
                return  String("e1r\(row)p\(pos - 1)")
            }
            else if (pos >= 11 && pos <= 15) {
                return  String("e1r\(row)p\(pos - 2)")
            }
            else if (pos >= 18 && pos <= 20) {
                return  String("e1r\(row)p\(pos - 4)")
            }
        } else if (row == 10 || row == 11) {
            if (pos >= 1 && pos <= 4) {
                return  String("e1r\(row)p\(pos)")
            }
            else if (pos >= 14 && pos <= 17) {
                return  String("e1r\(row)p\(pos - 9)")
            }
            else if (pos >= 18 && pos <= 20) {
                return  String("e1r\(row)p\(pos - 10)")
            }
        } else if (row == 12) {
            if (pos == 1 || pos == 2) {
                return  String("e1r\(row)p\(pos)")
            }
            else if (pos == 19 || pos <= 20) {
                return  String("e1r\(row)p\(pos - 16)")
            }
        }
        return ""
    }
}

extension ClusterViewController {
    func getClusterInfo(num: Int, completion: @escaping () -> ()) {
        let token = AuthUser.shared.tokenJson?["access_token"] as! String
        let intraURL = AuthUser.shared.intraURL
        let url = NSURL(string: "\(intraURL)/v2/campus/8/locations?page[size]=100&page[number]=\(num)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            print(num)
            do
            {
                guard let data = data else { return }
                self.ClusterLoggedUsers = try JSONDecoder().decode([ClusterUsers?].self, from: data)
                for i in 0..<self.ClusterLoggedUsers.count {
                    if self.ClusterLoggedUsers[i]?.end_at == nil {
//                        let login = self.ClusterLoggedUsers[i]?.user?.login
                        self.clusterDict.updateValue(self.ClusterLoggedUsers[i], forKey: self.ClusterLoggedUsers[i]?.host ?? "empty")
//                        guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login ?? "0").jpg") else { return }
//                        let session = URLSession.shared
//                        session.dataTask(with: url) {(data, response, error) in
//                            DispatchQueue.main.async {
//                                if let data = data, let image = UIImage(data: data) {
//                                    self.pictureDict.updateValue(image, forKey: self.ClusterLoggedUsers[i]?.host ?? "empty")
//                                }
//                            }
//                        }.resume()
                    }
                }
                completion()
            }
            catch let error {
                completion()
                return print("Another error:\(error)")
            }
        }.resume()
    }

}
