//
//  ClusterUserViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/11/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterUserViewController: UITableViewController {

    @IBOutlet weak var userViewPicture: UIImageView!
    @IBOutlet weak var userViewLogin: UILabel!
    @IBOutlet weak var userViewLocation: UILabel!
    @IBOutlet weak var userViewBeginSess: UILabel!
    @IBOutlet weak var userViewSessTime: UILabel!
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
        guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login ?? "").jpg") else { return }
        userViewPicture.kf.setImage(with: url)
        userViewLocation.text = location
        userViewLogin.text = login
        userViewBeginSess.text = beginSess
        userViewSessTime.text = sessTime
        tableView.reloadData()
    }

    func fetchFoundUserData(from controller: UIViewController, login: String) {
            var id: Int?
    
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToUserProfile") as? ProfileViewController else { return }
        guard let lc = self.storyboard?.instantiateViewController(withIdentifier: "loadController") as? LoadViewController else { return }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(lc, animated: false)
//
        }
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
//                    self.activityIndicator.isHidden = true
//                    self.activityIndicator.stopAnimating()
                    group.leave()
                }
            }
        }
    
    @IBAction func tapViewProfile(_ sender: UIBarButtonItem) {
        fetchFoundUserData(from: self, login: self.login!)
    }
}
