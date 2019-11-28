//
//  ProjectsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class AllProjectsViewController: UIViewController {
   
    @IBOutlet weak var projectsTableView: UITableView!
    var ProjectsInfo: [Projects]!
    
    override func viewDidLoad() {
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        print(ProjectsInfo!)
    }
}

extension AllProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var projects: Int = 0
        for i in 0..<ProjectsInfo.count
        {
             if ProjectsInfo[i].cursus_ids[0] == 1 {
             projects += 1
            }
        }
        print(projects)
        return projects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllProjectsCell", for: indexPath) as! AllProjectsTableViewCell
        if ProjectsInfo[indexPath.row].cursus_ids[0] == 1 {
//        && ProjectsInfo[indexPath.row].project?.parent_id == nil {
            cell.projectNameLabel.text = ProjectsInfo[indexPath.row].project?.name
            cell.projectStatusLabel.text = ProjectsInfo[indexPath.row].status
            
        }
        return cell
    }
}
