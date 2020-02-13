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
                self.performSegue(withIdentifier: "unwindToProfileViewController", sender: nil)
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
            SearchNetworkService.shared.getSearchData(from: url) { data in
                guard let data = data as? [UserSearch] else { return }
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

