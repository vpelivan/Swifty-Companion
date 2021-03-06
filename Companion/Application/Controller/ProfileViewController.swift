//
//  NewViewController.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/14/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    var searchController: UISearchController?
    var myInfo: UserData!
    var defaultCursus: CursusUser?
    var coalitionData: [Coalition?] = []
    var examsInternships: [ProjectsUsers?] = []
    var inProgressProjects: [ProjectsUser?] = []
    var exams: Int = 0
    var internships: Int = 0
    var partTime: Int = 0
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var searchNamesArray: [UserSearch] = []
    let intraURL = AuthUser.shared.intraURL
    var cellDict: [Int : Int] = [0:0, 1:1]
    var sessionTasks: [URLSessionDataTask?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        activityIndicator.isHidden = true
        if myInfo.cursusUsers?.isEmpty == false {
            setDefaultCursus()
        }
        setCellQuantity()
        setSearchBar()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
    
    @IBAction func tapLogOut(_ sender: Any) {
       let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        }
    }
    
    @objc func tapChangeCursus(_ sender: Any?) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "goToCursusChange") as! CursusTableViewController
        if myInfo.cursusUsers?.isEmpty == false {
            vc.cursusUsers = myInfo.cursusUsers
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapAllProjects(_ sender: Any?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AllProjects") as? AllProjectsViewController {
            vc.ProjectsInfo = self.myInfo.projectsUsers
            vc.defaultCursus = self.defaultCursus
            navigationController?.pushViewController(vc, animated: true)
        }
    }
       
    @objc func tapAllSkills(_sender: Any?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AllSkills") as? AllSkillsViewController {
            vc.skills = defaultCursus?.skills
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func setCellQuantity() {
        guard let cursusUsers = myInfo.cursusUsers else { return }
        var index: Int = 2
        if cursusUsers.isEmpty == false {
            cellDict[2] = index
            index += 1
        }
        if myInfo.projectsUsers?.isEmpty == false {
            cellDict[3] = index
            index += 1
        }
        if defaultCursus?.skills?.isEmpty == false {
            cellDict[4] = index
            index += 1
        }
    }
        
    fileprivate func getExamsInternships() {
        exams = 0
        internships = 0
        
        for project in examsInternships {
            if project?.project?.id == 11 {
                guard let projectTeams = project?.teams else { break }
                for team in projectTeams {
                    if team.validated == true && exams < 5 {
                        exams += 1
                    }
                }
            }
            else if (project?.project?.id == 118 || project?.project?.id == 212) {
                guard let projectTeams = project?.teams else { break }
                for team in projectTeams {
                    if team.validated == true && internships < 2 {
                        internships += 1
                    }
                }
            }
            else if ( project?.project?.id == 1650 || project?.project?.id == 1656) {
                guard let projectTeams = project?.teams else { break }
                for team in projectTeams {
                    if team.validated == true && partTime < 1 {
                        partTime += 1
                    }
                }
            }
        }
    }
    
    fileprivate func setDefaultCursus() {
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
        
        
        
    fileprivate func setTableView() {
        tableView.register(UINib(nibName: "CurrentProjectsViewCell", bundle: nil), forCellReuseIdentifier: "currentProjectsCell")
        tableView.register(UINib(nibName: "SkillsViewCell", bundle: nil), forCellReuseIdentifier: "someSkillsCell")
        tableView.tableFooterView = UIView(frame: .zero)
        if defaultCursus?.hasCoalition == true && coalitionData.isEmpty == false {
            if let coverUrl = URL(string: coalitionData[0]?.coverUrl ?? "") {
                NetworkService.shared.getImage(from: coverUrl) {image in
                    self.tableView.backgroundView = UIImageView(image: image)
                    self.tableView.backgroundView?.contentMode = .scaleAspectFill
                }
            }
        } else {
            let backgroundImage = UIImage(named: "background_login")
            tableView.backgroundView = UIImageView(image: backgroundImage)
            tableView.backgroundView?.contentMode = .scaleAspectFill
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func setSearchBar() {
            let searchTableView = storyboard!.instantiateViewController(withIdentifier: "SearchTableView") as! SearchTableView
        
            searchController = UISearchController(searchResultsController: searchTableView)
            searchController?.searchResultsUpdater = searchTableView
            searchController?.searchBar.placeholder = "Find a user"
            searchController?.searchBar.tintColor = colorCyan
            searchController?.hidesNavigationBarDuringPresentation = false
            searchController?.searchBar.delegate = searchTableView
            definesPresentationContext = true
            navigationItem.searchController = searchController
    }

    fileprivate func fetchProfileCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileViewCell
        
        if let imageUrl = URL(string: myInfo.imageURL ?? ""){
            NetworkService.shared.getImage(from: imageUrl) {image in
                cell.userImage.image = image
            }
        }
        if myInfo.staff != nil {
            if myInfo.staff == true {
                cell.staffLabel.isHidden = false
            }
        }
        if myInfo.campus?.isEmpty == false {
            if let city = myInfo.campus?[0].city, let country = myInfo.campus?[0].country {
                cell.userCampus.text = "\(city), \(country)"
            }
        }
        cell.userName.text = myInfo.displayname ?? "No Name"
        cell.userLogin.text = myInfo.login ?? "No Login"
        cell.userEmail.text = myInfo.email ?? "No Email"
        if defaultCursus?.hasCoalition == true && coalitionData.isEmpty == false {
            cell.cursusCoalition.text = "coalition: \(coalitionData[0]?.name ?? "No Info")"
        }
        cell.userPoints.text = "correction points: \(myInfo.correctionPoint ?? 0)"
        cell.userWallet.text = "wallet: \(myInfo.wallet ?? 0)₳"
        cell.userLocation.text = "location: \(myInfo.location ?? "Unavailable")"
        cell.userPool.text = "pool of: \(String(myInfo.poolMonth ?? "").capitalized) \(myInfo.poolYear ?? "")"
        return cell
    }
    
    fileprivate func fetchImages(with number: Int, for array: [UIImageView], with image: UIImage) -> [UIImageView] {
        if number >= 1 && number <= array.count {
            for i in 0..<number {
                array[i].image = image
            }
        }
        return array
    }
    
    fileprivate func fetchLevelCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "levelCell", for: indexPath) as! CurrentLevelViewCell
        let lvlFloat = defaultCursus?.level ?? 0.0
        let lvlProgressWhole = Int(lvlFloat)
        var lvlProgressRest = Float(0.0)
        if lvlProgressWhole > 0 {
            lvlProgressRest = lvlFloat - Float(lvlProgressWhole)
        } else {
            lvlProgressRest = lvlFloat
        }
        cell.level.text = String(defaultCursus?.level ?? 0.0)
        cell.levelProgress.progress = lvlProgressRest
        getExamsInternships()
        if let checkmarkImage = UIImage(named: "checkmark-white") {
            cell.checkmark = fetchImages(with: exams, for: cell.checkmark, with: checkmarkImage)
        }
        if let internImage = UIImage(named: "icons8-case-white") {
            cell.internship = fetchImages(with: internships, for: cell.internship, with: internImage)
            if partTime > 0 {
                cell.partTime.image = internImage
            }
        }
        return cell
    }
    
    fileprivate func fetchCursusCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CursusCell", for: indexPath) as! CurrentCursusViewCell
        cell.changeCursusButton.addTarget(self, action: #selector(ProfileViewController.tapChangeCursus(_:)), for: .touchUpInside)
        cell.cursusName.text = "name: \(defaultCursus?.cursus?.name ?? "No Name")"
        cell.cursusGrade.text = "grade: \(defaultCursus?.grade ?? "No Grade")"
        let begin = OtherMethods.shared.getDateAndTime(from: defaultCursus?.beginAt)
        cell.cursusStarted.text = "begin date: \(begin)"
        return cell
    }
    
    fileprivate func getInProgressProjects() {
        guard let projects = myInfo.projectsUsers, let defaultCursusID = defaultCursus?.cursusID else { return }
        if projects.isEmpty == false {
            inProgressProjects = []
            for project in projects {
                if project.cursusIDS?.isEmpty == false {
                    let cursusId = project.cursusIDS?[0]
                    if (project.status == "in_progress"
                        || project.status == "searching_a_group" || project.status == "waiting_for_correction" || project.status == "creating_group") && (project.project?.parentID == nil) && (cursusId == defaultCursusID) {
                        inProgressProjects.append(project)
                    }
                }
            }
        }
    }
    
    fileprivate func fetchProjectsCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentProjectsCell", for: indexPath) as! CurrentProjectsViewCell
        cell.allProjectsButton.addTarget(self, action: #selector(ProfileViewController.tapAllProjects(_:)), for: .touchUpInside)
        getInProgressProjects()
        switch inProgressProjects.count {
        case 0:
            cell.projectNameOne.isHidden = true
            cell.projectNameTwo.isHidden = true
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameEtcDots.text = "Not subscribed to any project"
        case 1:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = true
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = true
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
        case 2:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = false
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = true
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
            cell.projectNameTwo.text = inProgressProjects[1]?.project?.name
        case 3:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = false
            cell.projectNameThree.isHidden = false
            cell.projectNameEtcDots.isHidden = true
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
            cell.projectNameTwo.text = inProgressProjects[1]?.project?.name
            cell.projectNameThree.text = inProgressProjects[2]?.project?.name
        case 4...:
            cell.projectNameOne.isHidden = false
            cell.projectNameTwo.isHidden = false
            cell.projectNameThree.isHidden = false
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameEtcDots.text = "..."
            cell.projectNameOne.text = inProgressProjects[0]?.project?.name
            cell.projectNameTwo.text = inProgressProjects[1]?.project?.name
            cell.projectNameThree.text = inProgressProjects[2]?.project?.name
        default:
            cell.projectNameOne.isHidden = true
            cell.projectNameTwo.isHidden = true
            cell.projectNameThree.isHidden = true
            cell.projectNameEtcDots.isHidden = false
            cell.projectNameEtcDots.text = "..."
        }
        return cell
    }
    
    fileprivate func switchSomeSkills(to cell: SkillsViewCell, condition: [Bool], skills: [Skill], etc: String) -> UITableViewCell {
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
        cell.skillEtc.isHidden = condition[3]
        return cell
    }
    
    fileprivate func fetchSomeSkillsData(for indexPath: IndexPath)-> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "someSkillsCell", for: indexPath) as! SkillsViewCell
        cell.moreSkillsButton.addTarget(self, action: #selector(ProfileViewController.tapAllSkills(_sender:)), for: .touchUpInside)
        guard let skills = defaultCursus?.skills else { return cell }
        if skills.isEmpty == false {
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
        }
        return cell
    }
        
    @IBAction func unwindToProfileFromSearch(_ unwindSegue: UIStoryboardSegue) {
        guard let svc = unwindSegue.source as? SearchTableView else { return }
        guard let vc = svc.vc else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func unwindToProfileFromCursus(_ unwindSegue: UIStoryboardSegue) {
        guard let svc = unwindSegue.source as? CursusTableViewController else { return }
        self.defaultCursus = svc.chosenCursus
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.activityIndicator.isHidden == false {
            self.tableView.backgroundView = nil
            return 0
        }
        return cellDict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keys = (cellDict as NSDictionary).allKeys(for: indexPath.row) as! [Int]
        guard let key = keys.first else { return UITableViewCell() }
        
        switch key {
        case 0:
            return fetchProfileCell(for: indexPath)
        case 1:
            return fetchLevelCell(for: indexPath)
        case 2:
            return fetchCursusCell(for: indexPath)
        case 3:
            return fetchProjectsCell(for: indexPath)
        case 4:
            return fetchSomeSkillsData(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
}
