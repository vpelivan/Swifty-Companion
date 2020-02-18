//
//  NewViewController.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/14/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var searchController: UISearchController?
    var myInfo: UserData!
    var cellCount: Int = 1
    var defaultCursus: CursusUser!
    var coalitionData: [Coalition?] = []
    var examsInternships: [ProjectsUsers?] = []
    var inProgressProjects: [ProjectsUser?] = []
    var projectsNum: Int = 0
    var exams: Int = 0
    var internships: Int = 0
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var searchNamesArray: [UserSearch] = []
    let intraURL = AuthUser.shared.intraURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        activityIndicator.isHidden = true
        setCellQuantity()
        
//        getExamsInternships()
        setTableView()
        setSearchBar()
    }
    
    fileprivate func setCellQuantity() {
        guard let cursusUsers = myInfo.cursusUsers else { return }
        if cursusUsers.isEmpty == false {
            cellCount += 2 // one for cursus cell, another for level cell
            setDefaultCursus()
            getExamsInternships()
        }
        
    }
        
    fileprivate func getExamsInternships() {
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
                    if team.validated == true {
                        internships += 1
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
        let backgroundImage = UIImage(named: "background_login")
        tableView.backgroundView = UIImageView(image: backgroundImage)
        tableView.backgroundView?.contentMode = .scaleAspectFill
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

    fileprivate func fetchProfileCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! NewCellController
        if let imageUrl = URL(string: myInfo.imageURL ?? ""){
            NetworkService.shared.getImage(from: imageUrl) {image in
                cell.userImage.image = image
            }
        } else {
            cell.userImage.image = UIImage(named: "noImage")
        }
        if myInfo.campus?.isEmpty == false {
            cell.userLocation.text = "\(myInfo.campus?[0].city ?? ""), \(myInfo.campus?[0].country ?? "")"
        }
        cell.userName.text = myInfo.displayname ?? "No Name"
        cell.userLogin.text = myInfo.login ?? "No Login"
        cell.userEmail.text = myInfo.email ?? "No Email"
        cell.userPhone.text = "phone: \(myInfo.phone ?? "No Info")"
        cell.userPoints.text = "correction points: \(myInfo.correctionPoint ?? 0)"
        cell.userWallet.text = "wallet: \(myInfo.wallet ?? 0)₳"
        cell.userLocation.text = "location: \(myInfo.location ?? "Unavailable")"
        cell.userPool.text = "pool of: \(myInfo.poolMonth ?? "") \(myInfo.poolYear ?? "")"
        return cell
    }
    
}

extension NewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return fetchProfileCell(indexPath: indexPath)
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "levelCell", for: indexPath)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CursusCell", for: indexPath) as! CurrentCursusViewCell
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProjectsCell", for: indexPath) as! CurrentProjectsViewCell
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "someSkillsCell", for: indexPath) as! SkillsViewCell
            return cell
        }
        return UITableViewCell()
    }
}
