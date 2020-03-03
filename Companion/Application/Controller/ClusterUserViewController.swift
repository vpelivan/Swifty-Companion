//
//  ClusterUserViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/11/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewProfileButton: UIBarButtonItem!
    
    let intraURL = AuthUser.shared.intraURL
    var login: String?
    var location: String?
    var beginSess: String?
    var sessTime: String?
    var sessionTasks: [URLSessionDataTask?] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(login ?? "User")"
        tableView.tableFooterView = UIView(frame: .zero)
        self.activityIndicator.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if sessionTasks.isEmpty == false {
            for task in sessionTasks {
                guard let trueTask = task else { continue }
                if trueTask.state == .running {
                    trueTask.cancel()
                }
            }
        }
    }

    func fetchFoundUserData(login: String) {
        var id: Int?
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToUserProfile") as? ProfileViewController else { return }
        
        guard let url = URL(string: "\(intraURL)v2/users/\(login)") else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(800)) {
            let group = DispatchGroup()
            group.enter()
            let dataTask = NetworkService.shared.getDataWithoutAlarm(into: UserData.self, from: url) { User, result in
                guard let userInfo = User as? UserData else { return }
                guard let userId = userInfo.id else { return }
                id = userId
                vc.myInfo = userInfo
                group.leave()
            }
            self.sessionTasks.append(dataTask)
            group.wait()
            group.enter()
            guard let coalitionsUrl = URL(string: "\(self.intraURL)v2/users/\(id ?? 0)/coalitions") else { return }
            let coalitionTask = NetworkService.shared.getDataWithoutAlarm(into: [Coalition?].self, from: coalitionsUrl) { Coalition, result in
                guard let coalitionData = Coalition as? [Coalition] else { return }
                vc.coalitionData = coalitionData
                group.leave()
            }
            self.sessionTasks.append(coalitionTask)
            group.wait()
            sleep(1)
            group.enter()
            guard let url = URL(string: "\(self.intraURL)v2/projects_users?filter[project_id]=11,118,212,1650,1656&user_id=\(id ?? 0)") else { return }
            let examsInternshipsTask = NetworkService.shared.getDataWithoutAlarm(into: [ProjectsUsers].self, from: url) { examsInternships, result in
                guard let examsInternships = examsInternships as? [ProjectsUsers] else { return }
                vc.examsInternships = examsInternships
                group.leave()
            }
            self.sessionTasks.append(examsInternshipsTask)
            group.wait()
            group.enter()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.viewProfileButton.isEnabled = true
                group.leave()
            }
        }
    }
    
    @IBAction func tapViewProfile(_ sender: UIBarButtonItem) {
        guard let login = login else { return }
        fetchFoundUserData(login: login)
        tableView.reloadData()
        viewProfileButton.isEnabled = false
    }
}

extension ClusterUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityIndicator.isHidden == false {
            return 0
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userImageCell", for: indexPath) as! ClusterUserImageCell
            guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login ?? "").jpg") else { return UITableViewCell() }
            cell.useImage.kf.setImage(with: url)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! ClusterUserInfoCell
            cell.userViewLocation.text = location
            cell.userViewLogin.text = login
            cell.userViewBeginSess.text = beginSess
            cell.userViewSessTime.text = sessTime
            return cell
        }
    }
}
