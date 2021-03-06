//
//  ProjectsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/21/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class AllProjectsViewController: UIViewController {
    
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    let colorRed = #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
    let colorGreen = #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1)
    
    @IBOutlet weak var projectsTableView: UITableView!
    var ProjectsInfo: [ProjectsUser]?
    var token: String?
    var NeededProjects: [ProjectsUser] = []
    var defaultCursus: CursusUser?
    
    override func viewDidLoad() {
        getNeededProjects()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getNeededProjects() {
        if let projectsInfo = ProjectsInfo {
            for project in projectsInfo {
                if project.cursusIDS?.isEmpty == false {
                    if project.cursusIDS?[0] == defaultCursus?.cursusID && project.project?.parentID == nil {
                        NeededProjects.append(project)
                    }
                }
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
        let status = NeededProjects[indexPath.row].status
        let name = NeededProjects[indexPath.row].project?.name
        let validated = NeededProjects[indexPath.row].validated
        if status == "finished" {
            cell.nameLabel.text = name
            if validated == true {
                cell.statusLabel.text = status
                cell.nameLabel.textColor = self.colorGreen
                cell.statusLabel.textColor = self.colorGreen
            } else {
                cell.statusLabel.text = "failed"
                cell.nameLabel.textColor = self.colorRed
                cell.statusLabel.textColor = self.colorRed
            }
        } else {
            cell.nameLabel.text = name
            cell.nameLabel.textColor = self.colorCyan
            cell.statusLabel.textColor = self.colorCyan
            cell.statusLabel.text = status?.replacingOccurrences(of: "_", with: " ")
            cell.statusLabel.textColor = self.colorCyan
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController else { return }
            vc.projectInfo = self.NeededProjects[indexPath.row]
            vc.projectsInfo = self.ProjectsInfo
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
