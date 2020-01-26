//
//  SingleProjectViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/22/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SingleProjectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var colorCyan = UIColor(red: 82.0/255.0, green: 183.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    var colorRed = UIColor(red: 223.0/255.0, green: 134.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    var colorGreen = UIColor (red: 115.0/255.0, green: 182.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    var projectInfo: Projects!
    var token: String!
    var projectsInfo: [Projects]!
    var projectSessions: [ProjectsUsers]?
    var neededProjects: [Projects] = []
    var personsInTeam: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = projectInfo.project?.name
//        print(projectInfo)
        getPoolDays()
//        getProjectInfo()
//        getTeamsInfo()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    
    func getPoolDays() {
            for i in 0..<projectsInfo.count {
                if projectInfo.project?.id == projectsInfo[i].project?.parent_id {
                    neededProjects.append(projectsInfo[i])
                }
            }
        if neededProjects.count == 0 {
//            tableView.isHidden = true
        }
    }
    
    func fetchProjectInfo(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCell", for: indexPath) as! MarkTableViewCell
        
        if projectInfo.status == "in_progress" || projectInfo.status == "searching_a_group"
        || projectInfo.status == "creating_group" {
            cell.statusLabel.text = "subscribed"
            cell.markView.backgroundColor = colorCyan
            cell.markLabel.isHidden = true
            cell.of100Label.isHidden = true
            cell.imageStatus.isHidden = false
        } else if projectInfo.status == "finished" {
            if projectInfo.validated == 1 {
                cell.statusLabel.text = "success"
                cell.markView.backgroundColor = colorGreen
                cell.markLabel.isHidden = false
                cell.of100Label.isHidden = false
                cell.imageStatus.isHidden = true
                cell.markLabel.text = String(projectInfo.final_mark ?? 0)
            } else {
                cell.statusLabel.text = "fail"
                cell.markView.backgroundColor = colorRed
                cell.markLabel.isHidden = false
                cell.of100Label.isHidden = false
                cell.imageStatus.isHidden = true
                cell.markLabel.text = String(projectInfo.final_mark ?? 0)
            }
        }
        return cell
    }
}

extension SingleProjectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = fetchProjectInfo(for: indexPath)
            return cell
        default:
            break
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PooldDaysCell", for: indexPath) as! PoolDayTableViewCell
//        cell.dayName.text = neededProjects[indexPath.row].project?.name
//        cell.dayStatus.text = String(neededProjects[indexPath.row].final_mark ?? 0)
//        if neededProjects[indexPath.row].validated == 1 {
//            cell.dayStatus.textColor = colorGreen
//            cell.dayName.textColor = colorGreen
//        } else {
//            cell.dayStatus.textColor = colorRed
//            cell.dayName.textColor = colorRed
//        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController {
//            vc.projectInfo = self.neededProjects[indexPath.row]
//            vc.token = self.token!
//            vc.projectsInfo = self.projectsInfo
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

extension SingleProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.personsInTeam
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath)
        return cell
    }
    
    
}

extension SingleProjectViewController {
  
//    func getTeamsInfo() {
//        let intraURL = AuthUser.shared.intraURL
//        let urlUserProject = NSURL(string: "\(intraURL)/v2/projects_users/\(self.projectInfo.id ?? 0)")
//        let request = NSMutableURLRequest(url: urlUserProject! as URL)
//        let sessionUserProject = URLSession.shared
//        request.httpMethod = "GET"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        sessionUserProject.dataTask(with: request as URLRequest) {
//            (data, response, error) in
//            do {
//                guard let data = data else { return }
////                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
////                print(json)
//
//            }
//            catch let error {
//                print(error)
//            }
//            }.resume()
//    }
    
//    func getProjectInfo() {
//        let intraURL = AuthUser.shared.intraURL
//        let project_id = projectInfo.project?.id
//        let urlDescription = NSURL(string: "\(intraURL)/v2/cursus/1/projects?filter[id]=\(project_id ?? 0)&page[size]=100")
//        print(project_id ?? 0)
//        let request = NSMutableURLRequest(url: urlDescription! as URL)
//        let sessionDescription = URLSession.shared
//
//        request.httpMethod = "GET"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//
//
//        sessionDescription.dataTask(with: request as URLRequest) {
//            (data, response, error) in
//            do
//            {
//                guard let data = data else { return }
////                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
////                print(json)
//                self.projectSessions = try JSONDecoder().decode([ProjectsUsers]?.self, from: data)
//                DispatchQueue.main.async {
//                    if let count = self.projectSessions?[0].project_sessions.count {
////                        print(self.projectSessions?[0] ?? 0)
//                        for i in 0..<count {
//                            if self.projectSessions?[0].project_sessions[i]?.campus_id == 13 {
//                                self.descriptionView.text = self.projectSessions?[0].project_sessions[i]?.description
//                                guard let corrections = self.projectSessions?[0].project_sessions[0]?.scales else { return }
//                                if corrections.count > 0 {
//                                    self.correctionsLabel.text = String("Corrections needed: \(corrections[0]?.correction_number ?? 0)")
//                                }
//                                    break
//                            } else {
//                                self.descriptionView.text = self.projectSessions?[0].project_sessions[0]?.description
//                                guard let corrections = self.projectSessions?[0].project_sessions[0]?.scales else {return}
//                                if corrections.count > 0 {
//                                    self.correctionsLabel.text = String("Corrections needed: \(corrections[0]?.correction_number ?? 0)")
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            catch let error {
//                return print(error)
//            }
//            }.resume()
//    }
}

