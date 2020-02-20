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
    var searchController: UISearchController?
    var myInfo: UserData!
    var defaultCursus: CursusUser?
    var coalitionData: [Coalition?] = []
    var examsInternships: [ProjectsUsers?] = []
    var inProgressProjects: [ProjectsUser?] = []
    var projectsNum: Int = 0
    var exams: Int = 0
    var internships: Int = 0
    var partTime: Int = 0
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var searchNamesArray: [UserSearch] = []
    let intraURL = AuthUser.shared.intraURL
    var cellDict: [Int : Int] = [0:0, 1:1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        activityIndicator.isHidden = true
        if myInfo.cursusUsers?.isEmpty == false {
            setDefaultCursus()
        }
        setCellQuantity()
        setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setTableView()
        tableView.reloadData()
    }
    
    @IBAction func tapLogOut(_ sender: Any) {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
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
            searchController?.hidesNavigationBarDuringPresentation = true
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
        if myInfo.campus?.isEmpty == false {
            if let city = myInfo.campus?[0].city, let country = myInfo.campus?[0].country {
                cell.userCampus.text = "\(city), \(country)"
            }
        }
        cell.userName.text = myInfo.displayname ?? "No Name"
        cell.userLogin.text = myInfo.login ?? "No Login"
        cell.userEmail.text = myInfo.email ?? "No Email"
        cell.userPhone.text = "phone: \(myInfo.phone ?? "No Info")"
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
        if defaultCursus?.hasCoalition == true && coalitionData.isEmpty == false {
            cell.cursusCoalition.text = "coalition: \(coalitionData[0]?.name ?? "No Info")"
        }
        let begin = OtherMethods.shared.getDateAndTime(from: defaultCursus?.beginAt)
        cell.cursusStarted.text = "begin date: \(begin)"
        return cell
    }
    
    func fetchFoundUserData(from controller: UIViewController, login: String) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToUserProfile") as? ProfileViewController else { return }
        guard let url = URL(string: "\(intraURL)v2/users/\(login)") else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(1000)) {
            NetworkService.shared.getData(into: UserData.self, from: url) { User, result in
                guard let userInfo = User as? UserData else { return }
                vc.myInfo = userInfo
                guard let userId = userInfo.id else { return }
                guard let url = URL(string: "\(self.intraURL)v2/users/\(userId)/coalitions") else { return }
                DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    NetworkService.shared.getData(into: [Coalition?].self, from: url) { Coalition, result in
                        guard let coalitionData = Coalition as? [Coalition] else { return }
                        vc.coalitionData = coalitionData
                        guard let url = URL(string: "\(self.intraURL)v2/projects_users?filter[project_id]=11,118,212,1650,1656&user_id=\(userId)") else { return }
                        NetworkService.shared.getData(into: [ProjectsUsers].self, from: url) { examsInternships, result in
                            guard let examsInternships = examsInternships as? [ProjectsUsers] else { return }
                            vc.examsInternships = examsInternships
                            DispatchQueue.main.async {
                                self.navigationController?.pushViewController(vc, animated: true)
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToProfileFromCluster(_ unwindSegue: UIStoryboardSegue) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.reloadData()
        guard let svc = unwindSegue.source as? ClusterUserViewController else { return }
        guard let login = svc.login else { return }
        fetchFoundUserData(from: svc, login: login)
    }
    
    @IBAction func unwindToProfileFromSearch(_ unwindSegue: UIStoryboardSegue) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.reloadData()
        guard let svc = unwindSegue.source as? SearchTableView else { return }
        guard let login = svc.login else { return }
        fetchFoundUserData(from: svc, login: login)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProjectsCell", for: indexPath) as! CurrentProjectsViewCell
            cell.allProjectsButton.addTarget(self, action: #selector(ProfileViewController.tapAllProjects(_:)), for: .touchUpInside)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "someSkillsCell", for: indexPath) as! SkillsViewCell
            cell.moreSkillsButton.addTarget(self, action: #selector(ProfileViewController.tapAllSkills(_sender:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

