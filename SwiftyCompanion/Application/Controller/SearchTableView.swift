//
//  SearchTableView.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/4/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableView: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var searchNamesArray: [UserSearch] = []
    var login: String?
    var sessionTasks: [URLSessionDataTask?] = []
    let intraURL = AuthUser.shared.intraURL
    var vc: ProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
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
        tableView.reloadData()
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
            self.vc = vc
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
                group.leave()
            }
        }
    }
}

extension SearchTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let intraURL = AuthUser.shared.intraURL
        if searchController.searchBar.text != "" {
            guard let text = searchController.searchBar.text else { return }
            guard let url = URL(string: "\(intraURL)v2/users?search[login]=\(text)&sort=login") else { return }
            getSearchData(from: url) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension SearchTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityIndicator.isHidden == false {
            return 0
        }
        return  searchNamesArray.count
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if indexPath.row < searchNamesArray.count {
                guard let login = searchNamesArray[indexPath.row].login else {return cell}
                cell.textLabel?.text = login
                print(searchNamesArray[indexPath.row].login ?? "no value")
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let login = searchNamesArray[indexPath.row].login else { return }
    
            if indexPath.row < searchNamesArray.count {
                fetchFoundUserData(login: login)
            }
        }
}

extension SearchTableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        login = searchBar.text?.lowercased()
        self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
    }
}

extension SearchTableView {
    func getSearchData(from url: URL, completion: @escaping () -> ()) {
        guard let token = AuthUser.shared.token?.accessToken else { return }

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                guard let data = data else { return }
                let Data = try JSONDecoder().decode([UserSearch?].self, from: data)
                guard let decodedData = Data as? [UserSearch] else { return }
                print("data:", data)
                if data.isEmpty == false {
                    self.searchNamesArray = decodedData
                }
                completion()
            }
            catch let error {
                completion()
                print(error)
            }
        }.resume()
    }
}
