//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 10/25/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController?
    var myInfo: UserData!
    var coalitionData: [Coalition?] = []
    var examsInternships: [ProjectsUsers?] = []
    var inProgressProjects: [ProjectsUser?] = []
    var projectsNum: Int = 0
    var defaultCursus: CursusUser!
    var exams: Int = 0
    var internships: Int = 0
    var patronedBy: [UserPreview?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setDefaultCursus()
        getExamsInternships()
        tableView.register(UINib(nibName: "CurrentProjectsViewCell", bundle: nil), forCellReuseIdentifier: "CurrentProjectsCell")
        tableView.register(UINib(nibName: "SkillsViewCell", bundle: nil), forCellReuseIdentifier: "SomeSkillsCell")
        tableView.tableFooterView = UIView(frame: .zero)
        if let patrone = self.myInfo.patroned[0].
        guard let PatroneUrl = URL(string: "\(AuthUser.shared.intraURL)/v2/users/\(self.myInfo.patroned[0]?.godfatherID)") else {return}
        NetworkService.shared.getData(into: [UserPreview?].self, from: <#T##URL#>, completion: <#T##(Any, Result<String, Error>) -> ()#>)
        tableView.delegate = self
        tableView.dataSource = self

    }

    func setDefaultCursus() {
        guard let cursusUsers = myInfo.cursusUsers else { return }
        
        for cursus in cursusUsers {
            guard let neededCursusName = cursus.cursus?.name else { break }
            if neededCursusName == "42" {
                defaultCursus = cursus
                return
            }
        }
        defaultCursus = cursusUsers[0]
    }
    
    func getExamsInternships() {
        for project in examsInternships {
            if project?.project?.id == 11 {
                guard let projectTeams = project?.teams else { break }
                for team in projectTeams {
                    if team.validated == true {
                        exams += 1
                    }
                }
            }
            else if (project?.project?.id == 118 || project?.project?.id == 212) {
                guard let projectTeams = project?.teams else { break }
                for team in projectTeams {
                    if team.validated == true {
                        internships += 1
                    }
                }
            }
        }
    }
    
    @IBAction func tapChangeCursus(_ sender: UIButton) {

    }
    
    @objc func tapAllProjects(_ sender: Any?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AllProjects") as? AllProjectsViewController {
            vc.ProjectsInfo = self.myInfo.projectsUsers
//            vc.token = self.myInfo.tokenJson!["access_token"] as? String
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tapAllSkills(_sender: Any?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AllSkills") as? AllSkillsViewController {
            vc.skills = defaultCursus.skills
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func tapSearch(_ sender: UIBarButtonItem) {
        searchController?.searchBar.becomeFirstResponder()
    }
    
    @IBAction func tapLogOut(_ sender: UIBarButtonItem) {
        
    }
    
    func setSearchBar() {
        let searchTableView = storyboard!.instantiateViewController(withIdentifier: "SearchTableView") as! SearchTableView
        searchController = UISearchController(searchResultsController: searchTableView)
        searchController?.searchBar.placeholder = "Search user"
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = true
//        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    private func getInProgressProjects() {
        guard let projects = self.myInfo.projectsUsers else { return }
        for project in projects {
            if project.status == "in_progress"
            || project.status == "searching_a_group" {
                self.inProgressProjects.append(project)
                self.projectsNum += 1
            }
        }
    }
    
//    private func switchSomeProjects(to cell: CurrentProjectsViewCell, condition: [Bool], skills: [Skill], etc: String) -> UITableViewCell {
//        cell.projectNameOne.isHidden = condition[0]
//        cell.projectNameTwo.isHidden = condition[1]
//        cell.projectNameThree.isHidden = condition[2]
//        cell.projectNameEtcDots.isHidden = condition[3]
//        cell.projectNameOne.text = inProgressProjects[0]?.project?.name
//        cell.projectNameTwo.text = inProgressProjects[1]?.project?.name
//        cell.projectNameThree.text = inProgressProjects[2]?.project?.name
//        return cell
//    }
    
    func fetchCurrentProjectsData() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentProjectsCell") as! CurrentProjectsViewCell
        cell.setBorderdersToButton()
        cell.allProjectsButton.addTarget(self, action: #selector(ProfileViewController.tapAllProjects(_:)), for: .touchUpInside)
        getInProgressProjects()
        switch projectsNum {
        case 1:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = true
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
        case 2:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = false
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
            cell.projectNameTwo.text = inProgressProjects[1]?.project?.name
        case 3...:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = false
            cell.projectNameThree.isHidden = false
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
            cell.projectNameTwo.text = inProgressProjects[1]?.project?.name
            cell.projectNameThree.text = inProgressProjects[2]?.project?.name
        default:
            cell.projectNameOne.isHidden = true
            cell.projectNameTwo.isHidden = true
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameEtcDots.text = "Not subscribed to any project"
        }
        return cell
    }
    
    private func switchSomeSkills(to cell: SkillsViewCell, condition: [Bool], skills: [Skill], etc: String) -> UITableViewCell {
        cell.skillNameOne.isHidden = condition[0]
        cell.skillNameOne.text = skills[0].name
        cell.levelOne.isHidden = condition[0]
        cell.levelOne.text = String(skills[0].level ?? 0.0)
        cell.skillNameTwo.isHidden = condition[1]
        cell.skillNameTwo.text = skills[1].name
        cell.levelTwo.isHidden = condition[1]
        cell.levelTwo.text = String(skills[1].level ?? 0.0)
        cell.skillNameThree.isHidden = condition[2]
        cell.skillNameThree.text = skills[2].name
        cell.levelThree.isHidden = condition[2]
        cell.levelThree.text = String(skills[2].level ?? 0.0)
        cell.skillEtc.text = etc
        cell.levelOne.isHidden = condition[3]
        return cell
    }
    
    func fetchSomeSkillsData()-> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SomeSkillsCell") as! SkillsViewCell
        guard let skills = defaultCursus.skills else { return cell }
        switch skills.count {
        case 0:
            cell = switchSomeSkills(to: cell, condition: [true, true, true, false], skills: skills, etc: "No skills Avaliable") as! SkillsViewCell
        case 1:
            cell = switchSomeSkills(to: cell, condition: [false, true, true, true], skills: skills, etc: "") as! SkillsViewCell
        case 2:
            cell = switchSomeSkills(to: cell, condition: [false, false, true, true], skills: skills, etc: "") as! SkillsViewCell
        case 3:
            cell = switchSomeSkills(to: cell, condition: [false, false, false, true], skills: skills, etc: "") as! SkillsViewCell
        case 4...:
            cell = switchSomeSkills(to: cell, condition: [false, false, false, false], skills: skills, etc: "...") as! SkillsViewCell
        default:
            break
        }
        cell.moreSkillsButton.addTarget(self, action: #selector(ProfileViewController.tapAllSkills(_sender:)), for: .touchUpInside)
        cell.setBordersToButton()
        return cell
    }
    
    func fetchProfileData(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as! ProfileViewCell
        let lvlFloat = defaultCursus.level ?? 0.0
        let lvlProgressWhole = Int(lvlFloat)
        var lvlProgressRest = Float(0.0)
        
        if lvlProgressWhole > 0 {
            lvlProgressRest = lvlFloat - Float(lvlProgressWhole)
        } else {
            lvlProgressRest = lvlFloat
        }
        guard let imageUrl = URL(string: myInfo.imageURL ?? "") else { return cell }
        guard let coverUrl = URL(string: coalitionData[0]?.coverUrl ?? "") else { return cell }
        NetworkService.shared.getImage(from: imageUrl) {image in
            cell.profileImageView.image = image
        }
        NetworkService.shared.getImage(from: coverUrl) { image in
            cell.backgroundImageView.image = image
        }
        cell.profileNameLabel.text = myInfo.displayname
        cell.profileLoginLabel.text = myInfo.login
        cell.profileCampusLabel.text = "\(myInfo.campus?[0].city ?? "none"), \(myInfo.campus?[0].country ?? "none")"
        cell.profileEmailLabel.text = myInfo.email
        cell.profilePhoneLabel.text = "Phone: \(myInfo.phone ?? "none")"
        cell.someLabel.text = "Cursus: \(defaultCursus.cursus?.name ?? "none")"
        cell.profileCoalitionLabel.text = "Coalition: \(coalitionData[0]?.name ?? "none")"
        cell.profileLocationLabel.text = "Location: \(myInfo.location ?? "Unavaliable")"
        cell.profileWalletLabel.text = "Wallet: \(myInfo.wallet ?? 0)₳"
        cell.profileGradeLabel.text = "Grade: \(defaultCursus.grade ?? "no grade")"
        cell.profileCorrectionLabel.text = "Corrections: \(myInfo.correctionPoint ?? 0)"
        cell.profileLevelLabel.text = String(defaultCursus.level ?? 0.0)
        cell.profileProgressBar.progress = lvlProgressRest
        cell.profileExamsLabel.text = "Exams: \(exams) of 5"
        cell.profileInternLabel.text = "Internships: \(internships) of 2"
        cell.someLabel1.text = "Pool of: \(String(myInfo.poolMonth ?? "none").capitalized) \(myInfo.poolYear ?? "none")"
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return fetchProfileData(indexPath: indexPath)
        case 1:
            return fetchCurrentProjectsData()
        case 2:
            return fetchSomeSkillsData()
        default:
            return UITableViewCell()
        }
    }
}
