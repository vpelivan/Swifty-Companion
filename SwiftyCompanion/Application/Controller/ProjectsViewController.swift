//
//  ProjectsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
   
    @IBOutlet weak var projectsTableView: UITableView!
    var myInfo: UserInfo!
    
    override func viewDidLoad() {
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
    }
}

extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllProjectsTableViewCell", for: indexPath)
        return cell
    }
}
