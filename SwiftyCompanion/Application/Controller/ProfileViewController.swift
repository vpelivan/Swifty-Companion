//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 10/25/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var projectsMoreButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController?
    var myInfo: UserInfo!
    var inProgressProjects: [Projects?] = []
    var projectsNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CurrentProjectsViewCell", bundle: nil), forCellReuseIdentifier: "CurrentProjectsCell")
    }

    @IBAction func tapAllProjects(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AllProjects") as? AllProjectsViewController {
            vc.ProjectsInfo = self.myInfo.profileInfo?.projects_users as? [Projects]
            vc.token = self.myInfo.tokenJson!["access_token"] as? String
            navigationController?.pushViewController(vc, animated: true)
            //            present(vc, animated: true, completion: nil)
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
    
    func getInProgressProjects() {
        let userInfo = self.myInfo.profileInfo!

        for i in 0..<userInfo.projects_users.count {
            if userInfo.projects_users[i]?.status == "in_progress"
            || userInfo.projects_users[i]?.status == "searching_a_group" {
                self.inProgressProjects.append(userInfo.projects_users[i])
                self.projectsNum += 1
            }
        }
    }
    
    func fetchCurrentProjectsData() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentProjectsCell") as! CurrentProjectsViewCell
        cell.allProjectsButton.layer.borderWidth = 1.0
        cell.allProjectsButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
        getInProgressProjects()
        print("Number of Projects: ", projectsNum)
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
            cell.projectNameEtcDots.textColor = .black
        }
        return cell
    }
    
    func fetchSomeSkillsData(indexPath: IndexPath)-> UITableViewCell {
        return UITableViewCell()
    }
    
    func fetchProfileData(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as! ProfileViewCell
        let userData = myInfo.profileInfo
        let lvlFloat = userData?.cursus_users[0]?.level ?? 0.0
        let lvlProgressWhole = Int(lvlFloat)
        var lvlProgressRest = Float(0.0)
        
        if lvlProgressWhole > 0 {
            lvlProgressRest = lvlFloat - Float(lvlProgressWhole)
        } else {
            lvlProgressRest = lvlFloat
        }
        guard let url = URL(string: (userData?.image_url)!) else { return cell }
        guard let url1 = URL(string: (myInfo.coalitionInfo?.cover_url)!) else { return cell }
        let session = URLSession.shared
        session.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    cell.profileImageView.image = image
                }
            }
            }.resume()
        session.dataTask(with: url1) {(data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    cell.backgroundImageView.image = image
                }
            }
            }.resume()
        cell.profileNameLabel.text = userData?.first_name
        cell.profileSurnameLabel.text = userData?.last_name
        cell.profileLoginLabel.text = userData?.login
        cell.profileLocationLabel.text = String("Location: \(userData?.location ?? "Unavaliable")")
        cell.profileLevelLabel.text = String(userData?.cursus_users[0]?.level ?? 0.0)
        cell.profileProgressBar.progress = lvlProgressRest
        cell.profileWalletLabel.text = String("Wallet: \(userData?.wallet ?? 0)₳")
        cell.profileCorrectionLabel.text = String("Evaluation Poins: \(userData?.correction_point ?? 0)")
        cell.profileGradeLabel.text = String("Grade: \(userData?.cursus_users[0]?.grade ?? "no grade")")
        cell.profileEmailLabel.text = userData?.email
        cell.profileCampusLabel.text = String("\(userData?.campus[0]?.city ?? "none"), \(userData?.campus[0]?.country ?? "none")")
        cell.profileCoalitionLabel.text = String("Coalition: \(myInfo.coalitionInfo?.name ?? "none")")
        cell.profileExamsLabel.text = String("Exams: \(String(self.myInfo.examsPassed)) of 5")
        cell.profileInternLabel.text = String("Internships: \(String(self.myInfo.internPassed)) of 2")
        
        return cell
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let skills = self.myInfo?.profileInfo?.cursus_users[0]?.skills.count else { return 0 }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return fetchProfileData(indexPath: indexPath)
        case 1:
            return fetchCurrentProjectsData()
//        case 2:
//            return fetchSomeSkillsData(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if tableView == self.projectsTableView {
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController {
//                vc.projectInfo = self.inProgressProjects[indexPath.row]
//                vc.token = self.myInfo.tokenJson!["access_token"] as? String
//                vc.projectsInfo = self.myInfo.profileInfo?.projects_users as? [Projects]
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }

}
