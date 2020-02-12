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
    var searchedLogin: String?
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: .zero)
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  searchNamesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        cell.textLabel?.text = searchNamesArray[indexPath.row].login
        print(searchNamesArray[indexPath.row].login ?? "no value")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchedLogin = searchNamesArray[indexPath.row].login
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToProfileViewController", sender: nil)
        }
    }
}

extension SearchTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let intraURL = AuthUser.shared.intraURL
        guard let url = URL(string: "\(intraURL)v2/users?search[login]=\(searchController.searchBar.text ?? "")&sort=login") else { return }
        NetworkService.shared.getDataWithoutAlarm(into: [UserSearch?].self, from: url) {(data, error) in
            guard let data = data as? [UserSearch] else { return }
            self.searchNamesArray = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}
