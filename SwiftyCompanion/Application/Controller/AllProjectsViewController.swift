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
    var token: String?
    var NeededProjects: [Projects] = []
    
    override func viewDidLoad() {
        getNeededProjects()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getNeededProjects() {
        for i in 0..<ProjectsInfo.count {
            if ProjectsInfo[i].cursus_ids[0] == 1 && ProjectsInfo[i].project?.parent_id == nil {
                NeededProjects.append(ProjectsInfo[i])
            }
        }
    }
    
//    func getNeededTeam(from json: NSDictionary?) -> Teams {
//
//    }

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
            if validated == 1 {
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
                    vc.token = self.token!
                    vc.projectsInfo = self.ProjectsInfo
                    vc.teams = teams
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
