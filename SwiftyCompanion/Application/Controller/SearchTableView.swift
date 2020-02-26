//
//  SearchTableView.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/4/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SearchTableView: UITableViewController {
    
    var searchNamesArray: [UserSearch] = []
    var login: String?
    var sessionTasks: [URLSessionDataTask?] = []
    let intraURL = AuthUser.shared.intraURL
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: .zero)
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchNamesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        if indexPath.row < searchNamesArray.count {
            cell.textLabel?.text = searchNamesArray[indexPath.row].login
            print(searchNamesArray[indexPath.row].login ?? "no value")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < searchNamesArray.count {
            login = searchNamesArray[indexPath.row].login
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
            }
//            fetchFoundUserData(from: self, login: self.login!)
        }
    }
    
//    func fetchFoundUserData(from controller: UIViewController, login: String) {
//        var id: Int?
//
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToUserProfile") as? ProfileViewController else { return }
//        guard let url = URL(string: "\(intraURL)v2/users/\(login)") else { return }
//        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(800)) {
//            let group = DispatchGroup()
//            group.enter()
//            let dataTask = NetworkService.shared.getDataWithoutAlarm(into: UserData.self, from: url) { User, result in
//                guard let userInfo = User as? UserData else { return }
//                guard let userId = userInfo.id else { return }
//                id = userId
//                vc.myInfo = userInfo
//                group.leave()
//            }
//            self.sessionTasks.append(dataTask)
//            group.wait()
//            group.enter()
//            guard let coalitionsUrl = URL(string: "\(self.intraURL)v2/users/\(id ?? 0)/coalitions") else { return }
//            let coalitionTask = NetworkService.shared.getDataWithoutAlarm(into: [Coalition?].self, from: coalitionsUrl) { Coalition, result in
//                guard let coalitionData = Coalition as? [Coalition] else { return }
//                vc.coalitionData = coalitionData
//                group.leave()
//            }
//            self.sessionTasks.append(coalitionTask)
//            group.wait()
//            sleep(1)
//            group.enter()
//            guard let url = URL(string: "\(self.intraURL)v2/projects_users?filter[project_id]=11,118,212,1650,1656&user_id=\(id ?? 0)") else { return }
//            let examsInternshipsTask = NetworkService.shared.getDataWithoutAlarm(into: [ProjectsUsers].self, from: url) { examsInternships, result in
//                guard let examsInternships = examsInternships as? [ProjectsUsers] else { return }
//                vc.examsInternships = examsInternships
//                group.leave()
//            }
//            self.sessionTasks.append(examsInternshipsTask)
//            group.wait()
//            group.enter()
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(vc, animated: true)
//                self.activityIndicator.isHidden = true
//                self.activityIndicator.stopAnimating()
//                group.leave()
//            }
//        }
//    }
}

extension SearchTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let intraURL = AuthUser.shared.intraURL
        if searchController.searchBar.text != "" {
            guard let text = searchController.searchBar.text else { return }
            guard let url = URL(string: "\(intraURL)v2/users?search[login]=\(text)&sort=login") else { return }
            SearchNetworkService.shared.getSearchData(from: url) { data in
                guard let data = data as? [UserSearch] else { return }
                print("data:", data)
                if data.isEmpty == false {
                    self.searchNamesArray = data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension SearchTableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        login = searchBar.text?.lowercased()
        self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
    }
}
