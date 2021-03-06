//
//  SingleProjectViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/22/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import Foundation

class SingleProjectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var colorRed = #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
    var colorGreen = #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1)
    var projectInfo: ProjectsUser!
    var token: String!
    var projectsInfo: [ProjectsUser]!
    var teams: projectTeams?
    var projectSessions: [ProjectsSessions]?
    var neededProjects: [ProjectsUser] = []
    var personsInTeam: Int = 1
    var teamsCount: Int {
        return teams?.teams?.count ?? 0
    }
    var collViewTeamIndex: Int = 0
    var collViewUsersIndex: Int = 0
    var cellDict: [Int : Int] = [0:0, 1:1]
    var sessionTasks: [URLSessionDataTask?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        navigationItem.title = projectInfo.project?.name
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        activityIndicator.isHidden = true
//        activityIndicator.stopAnimating()
//        tableView.reloadData()
//    }

    fileprivate func setCellQuantity() {
        guard let teams = teams?.teams else { return }
        var index: Int = 2
        if teams.isEmpty == false {
            for i in 0..<teamsCount {
                cellDict[i + 2] = index
                index += 1
            }
        }
        if neededProjects.isEmpty == false {
            for i in 0..<neededProjects.count {
                cellDict[i + 2 + teams.count] = index
                index += 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if sessionTasks.isEmpty == false {
            for task in sessionTasks {
                guard let trueTask = task else { continue }
                if trueTask.state == .running {
                    trueTask.cancel()
                }
            }
        }
    }
    
    func fetchData() {
        let intraURL = AuthUser.shared.intraURL
        guard let projectId = self.projectInfo.project?.id else { return }
        guard let projectInfoUrl = URL(string: "\(intraURL)/v2/cursus/1/projects?filter[id]=\(projectId)&page[size]=100") else { return }
        guard let urlUserProject = URL(string: "\(intraURL)/v2/projects_users/\(self.projectInfo?.id ?? 0)") else { return }
        ProjectNetworkService.shared.getProjectInfo(from: projectInfoUrl) { projectSessions, _ in
            ProjectNetworkService.shared.getTeamsInfo(url: urlUserProject) { teams, _ in
                self.projectSessions = projectSessions
                self.teams = teams
                self.getPoolDays()
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.setCellQuantity()
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getPoolDays() {
        for i in 0..<projectsInfo.count {
            if projectInfo.project?.id == projectsInfo[i].project?.parentID {
                neededProjects.append(projectsInfo[i])
            }
        }
    }
    
    func fetchPoolDays(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PoolDaysCell", for: indexPath) as! PoolDayTableViewCell
        cell.dayName.text = neededProjects[indexPath.row - 2 - teamsCount].project?.name
        cell.dayStatus.text = String(neededProjects[indexPath.row - 2 - teamsCount].finalMark ?? 0)
        if neededProjects[indexPath.row - 2 - teamsCount].validated == true {
            cell.dayStatus.textColor = colorGreen
            cell.dayName.textColor = colorGreen
        } else {
            cell.dayStatus.textColor = colorRed
            cell.dayName.textColor = colorRed
        }
        return cell
    }
    
    func fetchTeamInfo(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamsCell", for: indexPath) as! TeamsViewCell
        guard let teamInfo = teams?.teams?[indexPath.row - 2] else { return cell }
        collViewTeamIndex = indexPath.row - 2
        if let mark = teamInfo.finalMark {
            cell.finalMark.text = "Final mark: \(mark)"
        } else {
            cell.finalMark.text = "Final mark: -"
        }
        cell.teamName.text = "Team: \"\(teamInfo.name ?? "-")\""
        cell.createdAt.text = "Created at: \(OtherMethods.shared.getDateAndTime(from: teamInfo.createdAt))"
        cell.closedAt.text = "Closed at: \(OtherMethods.shared.getDateAndTime(from: teamInfo.closedAt))"
        cell.updatedAt.text = "Updated at: \(OtherMethods.shared.getDateAndTime(from: teamInfo.updatedAt))"
        cell.validated.text = "Validated: \(teamInfo.validated ?? false)"
        return cell
    }
    
    func fetchProjectDescription(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! ProjectDescriptionCell
        if projectSessions?.isEmpty == false {
            if let count = self.projectSessions?[0].projectSessions.count {
                for i in 0..<count {
                    if self.projectSessions?[0].projectSessions[i]?.campus_id == 13
                        && self.projectSessions?[0].projectSessions[i]?.description != nil
                        && self.projectSessions?[0].projectSessions[i]?.description != "" {
                        cell.descriptionLabel.text = self.projectSessions?[0].projectSessions[i]?.description
                        return cell
                    }
                }
                if self.projectSessions?[0].projectSessions[0]?.description != nil
                    && self.projectSessions?[0].projectSessions[0]?.description != "" {
                    cell.descriptionLabel.text = self.projectSessions?[0].projectSessions[0]?.description
                    return cell
                }
            }
        }
        cell.descriptionLabel.text = "No Description"
        return cell
    }
    
    func getWeeksOrDays(from value: Int?) -> String {
        if let value = value {
            let dayMeasure: Int = value / 86400
            let weekMeasure: Int = value / 604800
            switch dayMeasure {
            case 1:
                return "one day"
            case 2, 3, 4, 5, 6:
                return "\(dayMeasure) days"
            default:
                break
            }
            switch weekMeasure {
            case 1:
                return "one week"
            case 2...:
                return "\(weekMeasure) weeks"
            default:
                break
            }
        }
        return "no time"
    }
    
    func fetchProjectInfo(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCell", for: indexPath) as! MarkTableViewCell
        var solo: Bool = true
        var difficulty: Int = 100
        var time: Int = 0
        if projectSessions?.isEmpty == false {
            guard let sessions = projectSessions?[0].projectSessions else { return cell }
            
            for i in 0..<sessions.count {
                if sessions[i]?.campus_id == 8 && sessions[i]?.difficulty != nil {
                    guard let soloJ = sessions[i]?.solo, let difficultyJ = sessions[i]?.difficulty, let timeJ = sessions[i]?.estimate_time else { break }
                    solo = soloJ
                    difficulty = difficultyJ
                    time = timeJ
                    break
                } else if sessions[i]?.difficulty != nil && sessions[i]?.estimate_time != nil && sessions[i]?.solo != nil {
                    guard let soloJ = sessions[i]?.solo, let difficultyJ = sessions[i]?.difficulty, let timeJ = sessions[i]?.estimate_time else { break }
                    solo = soloJ
                    difficulty = difficultyJ
                    time = timeJ
                }
            }
            
            guard let correctionsArray = projectSessions?[0].projectSessions[0] else { return cell }
            for i in 0..<correctionsArray.scales.count {
                if let number = correctionsArray.scales[i]?.correction_number {
                    if number > 0 {
                        if correctionsArray.campus_id == 8  {
                            cell.correctionsLabel.text = "Corrections needed: \(number)"
                            break
                        }
                        cell.correctionsLabel.text = "Corrections needed: \(number)"
                    }
                }
            }
        }
        cell.projectType.text = "\(solo ? "solo" : "group") - \(getWeeksOrDays(from: time)) - \(difficulty)xp"
        
        if projectInfo.status == "finished" {
            if projectInfo.validated == true {
                cell.statusLabel.text = "success"
                cell.checkboxImage.isHidden = false
                cell.checkboxImage.image = UIImage(named: "icon-checkmark")
                cell.markView.backgroundColor = colorGreen
                cell.markLabel.isHidden = false
                cell.of100Label.isHidden = false
                cell.imageStatus.isHidden = true
                cell.markLabel.text = String(projectInfo.finalMark ?? 0)
            } else {
                cell.statusLabel.text = "fail"
                cell.markView.backgroundColor = colorRed
                cell.checkboxImage.isHidden = false
                cell.markLabel.isHidden = false
                cell.of100Label.isHidden = false
                cell.imageStatus.isHidden = true
                cell.markLabel.text = String(projectInfo.finalMark ?? 0)
            }
        } else {
            cell.statusLabel.text = "subscribed"
            cell.markView.backgroundColor = colorCyan
            cell.markLabel.isHidden = true
            cell.of100Label.isHidden = true
            cell.imageStatus.isHidden = false
        }
        return cell
    }
    
    func fetchFoundUserData(login: String) {
        var id: Int?
        let intraURL = AuthUser.shared.intraURL
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToUserProfile") as? ProfileViewController else { return }
        
        guard let url = URL(string: "\(intraURL)v2/users/\(login)") else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(800)) {
            let group = DispatchGroup()
            group.enter()
            let dataTask = NetworkService.shared.getDataWithoutAlarm(into: UserData.self, from: url) { User, result in
                guard let userInfo = User as? UserData else { return }
                guard let userId = userInfo.id else { return }
                id = userId
                vc.myInfo = userInfo
                group.leave()
            }
            self.sessionTasks.append(dataTask)
            group.wait()
            group.enter()
            guard let coalitionsUrl = URL(string: "\(intraURL)v2/users/\(id ?? 0)/coalitions") else { return }
            let coalitionTask = NetworkService.shared.getDataWithoutAlarm(into: [Coalition?].self, from: coalitionsUrl) { Coalition, result in
                guard let coalitionData = Coalition as? [Coalition] else { return }
                vc.coalitionData = coalitionData
                group.leave()
            }
            self.sessionTasks.append(coalitionTask)
            group.wait()
            sleep(1)
            group.enter()
            guard let url = URL(string: "\(intraURL)v2/projects_users?filter[project_id]=11,118,212,1650,1656&user_id=\(id ?? 0)") else { return }
            let examsInternshipsTask = NetworkService.shared.getDataWithoutAlarm(into: [ProjectsUsers].self, from: url) { examsInternships, result in
                guard let examsInternships = examsInternships as? [ProjectsUsers] else { return }
                vc.examsInternships = examsInternships
                group.leave()
            }
            self.sessionTasks.append(examsInternshipsTask)
            group.wait()
            group.enter()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                group.leave()
            }
        }
    }
}

extension SingleProjectViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityIndicator.isHidden == false {
            return 0
        }
        return cellDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keys = (cellDict as NSDictionary).allKeys(for: indexPath.row) as! [Int]

        let teamsCount = self.teamsCount + 2
        guard let key = keys.first else { return UITableViewCell() }
        switch key {
        case 0:
            return fetchProjectInfo(for: indexPath)
        case 1:
            return fetchProjectDescription(for: indexPath)
        case 2..<teamsCount:
            return fetchTeamInfo(for: indexPath)
        case (teamsCount)..<(teamsCount + self.neededProjects.count):
            return fetchPoolDays(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= teamsCount + 2 {
            DispatchQueue.main.async {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController else { return }
                vc.projectSessions = self.projectSessions
                vc.projectInfo = self.neededProjects[indexPath.row - (self.teamsCount + 2)]
                vc.projectsInfo = self.projectsInfo
                vc.teams = self.teams
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}

extension SingleProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mateNumber = teams?.teams?[collViewTeamIndex].users?.count else { return 0 }
        return mateNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeammateCollectionViewCell
        guard let mateData = teams?.teams?[collViewTeamIndex].users?[collViewUsersIndex] else { return  cell }
        guard let imageUrl = URL(string: "https://cdn.intra.42.fr/users/\(mateData.login ?? "").jpg") else { return  cell }
        guard let mateNumber = teams?.teams?[collViewTeamIndex].users?.count else { return cell }
            cell.userPicture.kf.setImage(with: imageUrl)
            cell.loginLabel.text = mateData.login
            if mateData.leader == false {
                cell.leaderStar.isHidden = true
            }
        if self.collViewUsersIndex < mateNumber - 1 {
            self.collViewUsersIndex += 1
        } else {
            self.collViewUsersIndex = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! TeammateCollectionViewCell
        guard let login = cell.loginLabel.text else { return }
        if login != AuthUser.shared.login {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            tableView.reloadData()
            fetchFoundUserData(login: login)
        }
    }
}
