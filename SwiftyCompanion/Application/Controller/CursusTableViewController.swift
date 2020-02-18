//
//  CursusTableViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/18/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class CursusTableViewController: UITableViewController {

    var cursusUsers: [CursusUser]?
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cursuses = cursusUsers?.count {
            return cursuses
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cursusCell", for: indexPath)
        cell.textLabel?.text = cursusUsers?[indexPath.row].cursus?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}
