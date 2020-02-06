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
    var ProjectsInfo: [ProjectsUser]!
    var token: String?
    var NeededProjects: [ProjectsUser] = []
    
    override func viewDidLoad() {
        getNeededProjects()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getNeededProjects() {
        for project in ProjectsInfo {
            if project.cursusIDS?[0] == 1 && project.project?.parentID == nil {
                NeededProjects.append(project)
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
        if status == "in_progress" || status == "searching_a_group" ||
            status == "creating_group" {
            cell.nameLabel.text = name
            cell.nameLabel.textColor = self.colorCyan
            cell.statusLabel.textColor = self.colorCyan
            if status == "in_progress" {
                cell.statusLabel.text = "in progress"
            } else if status == "searching_a_group" {
                cell.statusLabel.text = "searching a group"
            } else if status == "creating_group" {
                cell.statusLabel.text = "creating group"
            }
            cell.statusLabel.textColor = self.colorCyan
        } else if status == "finished" {
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let intraURL = AuthUser.shared.intraURL
        guard let projectId = self.NeededProjects[indexPath.row].project?.id else { return }
        guard let projectInfoUrl = URL(string: "\(intraURL)/v2/cursus/1/projects?filter[id]=\(projectId)&page[size]=100") else { return }
        guard let urlUserProject = URL(string: "\(intraURL)/v2/projects_users/\(self.NeededProjects[indexPath.row].id ?? 0)") else { return }
        ProjectNetworkService.shared.getProjectInfo(from: projectInfoUrl) { projectSessions in
            ProjectNetworkService.shared.getTeamsInfo(url: urlUserProject) { teams in
                DispatchQueue.main.async {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController else { return }
                    vc.projectSessions = projectSessions
                    vc.projectInfo = self.NeededProjects[indexPath.row]
                    vc.projectsInfo = self.ProjectsInfo
                    vc.teams = teams
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
