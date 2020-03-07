//
//  ClusterViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import Kingfisher

class ClusterViewController: UIViewController {
    
    //    var ClusterLoggedUsers: [ClusterUsers?] = []
    var clusterDict: [String : ClusterUsers?] = [:]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var sessionTasks: [URLSessionDataTask?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        collectionView.isScrollEnabled = true
        collectionView.reloadData()
        navigationController?.navigationBar.tintColor = colorCyan
        getClusterData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearBuffer()
    }
    
    func clearBuffer() {
        if sessionTasks.isEmpty == false {
            for task in sessionTasks {
                guard let trueTask = task else { continue }
                if trueTask.state == .running {
                    trueTask.cancel()
                }
            }
        }
    }
    
    func getClusterData() {
        DispatchQueue.global().async {
            self.clusterDict = [:]
            let group = DispatchGroup()
            var flag = false
            for i in 1... {
                group.enter()
                let task = self.getClusterInfo(num: i)  {
                    clusterLogged in
                    if clusterLogged.isEmpty == false {
                        for user in clusterLogged {
                            let host = user?.host
                            self.clusterDict.updateValue(user, forKey: host ?? "empty")
                        }
                    }
                    else {
                        flag = true
                    }
                    group.leave()
                }
                group.wait()
                if flag == true {
                    break
                }
                self.sessionTasks.append(task)
                if i != 0 && i % 2 == 0 {
                    sleep(1)
                }
            }
            group.enter()
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.navigationController?.navigationBar.topItem?.title = "\(self.clusterDict.count) users logged in Cluster"
                if self.refreshButton.isEnabled == false {
                    self.refreshButton.isEnabled = true
                }
                group.leave()
            }
        }
    }
    
    
    @IBAction func tapRefresh(_ sender: UIBarButtonItem) {
        refreshButton.isEnabled = false
        clearBuffer()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getClusterData()
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
            guard let login = clusterDict["\(location)"]??.user?.login else { return }
            guard let beginFromDict = self.clusterDict["\(location)"]??.begin_at else { return }
            var begin = beginFromDict.prefix(16).replacingOccurrences(of: "T", with: " ")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            let beginGMT = dateFormatter.date(from: begin)!
            begin = dateFormatter.string(from: beginGMT.addingTimeInterval(7200))
            let end = dateFormatter.string(from: Date())
            let beginDate = dateFormatter.date(from: begin)!
            let endDate = dateFormatter.date(from: end)!
            let difference = Calendar.current.dateComponents([.hour, .minute], from: beginDate, to: endDate)
            let formattedHourString = String(format: "%2ld", difference.hour!)
            let formattedMinuteString = String(format: "%02ld", difference.minute!)
            let BeginSess = "Began At: \(begin)"
            let SessTime = "Session Time: \(formattedHourString):\(formattedMinuteString) hour(s)"
            performSegue(withIdentifier: "goToClusterUser", sender: (location, login, BeginSess, SessTime))
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
                guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login).jpg") else { return loggedMacCell }
                loggedMacCell.imageView.kf.setImage(with: url)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let uvc = segue.destination as? ClusterUserViewController else { return }
        guard let senderForSure = sender as? (String, String, String, String) else { return }
        uvc.location = "Location: \(senderForSure.0)"
        uvc.login = senderForSure.1
        uvc.beginSess = senderForSure.2
        uvc.sessTime = senderForSure.3
    }
}

extension ClusterViewController {
    func getClusterInfo(num: Int, completion: @escaping ([ClusterUsers?]) -> ()) -> URLSessionDataTask? {
        guard let token = AuthUser.shared.token?.accessToken else { return nil }
        let intraURL = AuthUser.shared.intraURL
        let url = NSURL(string: "\(intraURL)/v2/campus/8/locations?page[size]=100&page[number]=\(num)&filter[end]=false")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            print(num)
            do
            {
                guard let data = data else { return }
                let clusterLogged = try JSONDecoder().decode([ClusterUsers?].self, from: data)
                completion(clusterLogged)
            }
            catch let error {
                completion([ClusterUsers?]())
                return print("Another error:\(error)")
            }
        }
        task.resume()
        return task
    }
}
