//
//  ProjectsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class AllProjectsViewController: UIViewController {
   
    let colorCyan = UIColor(red: 82.0/255.0, green: 183.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    let colorRed = UIColor(red: 223.0/255.0, green: 134.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    let colorGreen = UIColor (red: 115.0/255.0, green: 182.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var projectsTableView: UITableView!
    var ProjectsInfo: [Projects]!
    var NeededProjects: [Projects] = []
    
    override func viewDidLoad() {
        getNeededProjects()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
    }
    
    func getNeededProjects() {
        for i in 0..<ProjectsInfo.count {
            if ProjectsInfo[i].cursus_ids[0] == 1 && ProjectsInfo[i].project?.parent_id == nil {
                NeededProjects.append(ProjectsInfo[i])
            }
        }
    }
}

extension AllProjectsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NeededProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllProjectsCell", for: indexPath) as! AllProjectsTableViewCell
                        if NeededProjects[indexPath.row].status == "in_progress" || NeededProjects[indexPath.row].status == "searching_a_group" {
                            cell.projectNameLabel.text = NeededProjects[indexPath.row].project?.name
                            cell.projectNameLabel.textColor = self.colorCyan
                            cell.projectStatusLabel.textColor = self.colorCyan
                            if NeededProjects[indexPath.row].status == "in_progress" {
                                cell.projectStatusLabel.text = "in progress"
                            } else {
                                cell.projectStatusLabel.text = "searching a group"
                            }
                            cell.projectStatusLabel.textColor = self.colorCyan
                        } else if NeededProjects[indexPath.row].status == "finished" {
                            cell.projectNameLabel.text = NeededProjects[indexPath.row].project?.name
                            if NeededProjects[indexPath.row].validated == 1 {
                                cell.projectStatusLabel.text = NeededProjects[indexPath.row].status
                                cell.projectNameLabel.textColor = self.colorGreen
                                cell.projectStatusLabel.textColor = self.colorGreen
                            } else {
                                cell.projectStatusLabel.text = "failed"
                                cell.projectNameLabel.textColor = self.colorRed
                                cell.projectStatusLabel.textColor = self.colorRed
                            }
                        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.projectsTableView {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController {
                vc.projectInfo = self.NeededProjects[indexPath.row]
                vc.projectsInfo = self.ProjectsInfo
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
