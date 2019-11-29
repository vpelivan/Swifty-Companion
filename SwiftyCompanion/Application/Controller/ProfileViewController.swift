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
    @IBOutlet weak var profileViewConstr: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileSurnameLabel: UILabel!
    @IBOutlet weak var profileLoginLabel: UILabel!
    @IBOutlet weak var profileCampusLabel: UILabel!
    @IBOutlet weak var profilePhoneLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profileLocationLabel: UILabel!
    @IBOutlet weak var profileLevelLabel: UILabel!
    @IBOutlet weak var profileProgressBar: UIProgressView!
    @IBOutlet weak var profileCoalitionLabel: UILabel!
    @IBOutlet weak var profileWalletLabel: UILabel!
    @IBOutlet weak var profileGradeLabel: UILabel!
    @IBOutlet weak var profileInternLabel: UILabel!
    @IBOutlet weak var profileExamsLabel: UILabel!
    @IBOutlet weak var profileCorrectionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var skillsTableView: UITableView!
    
    
    var searchController: UISearchController?
    var myInfo: UserInfo!
    var inProgressProjects: [Projects?] = []
    var projectsNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setFramesForElems()
        fetchUserData()
        getInProgressProjects()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        skillsTableView.delegate = self
        skillsTableView.dataSource = self
        self.profilePhoneLabel.isHidden = true
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
    
    func setSearchBar() {
        let searchTableView = storyboard!.instantiateViewController(withIdentifier: "SearchTableView") as! SearchTableView
        searchController = UISearchController(searchResultsController: searchTableView)
        searchController?.searchBar.placeholder = "Search user"
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func fetchUserData() {
        let userData = self.myInfo.profileInfo
        let lvlFloat = userData?.cursus_users[0]?.level ?? 0.0
        let lvlProgressWhole = Int(lvlFloat)
        var lvlProgressRest = Float(0.0)
        
        if lvlProgressWhole > 0 {
            lvlProgressRest = lvlFloat - Float(lvlProgressWhole)
        } else {
            lvlProgressRest = lvlFloat
        }
        
        guard let url = URL(string: (userData?.image_url)!) else { return }
        guard let url1 = URL(string: (myInfo.coalitionInfo?.cover_url)!) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.profileImageView.image = image
                }
            }
            }.resume()
        session.dataTask(with: url1) {(data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.backgroundImageView.image = image
                }
            }
            }.resume()
        profileNameLabel.text = userData?.first_name
        profileSurnameLabel.text = userData?.last_name
        profileLoginLabel.text = userData?.login
        profileLocationLabel.text = String("Location: \(userData?.location ?? "Unavaliable")")
        profileLevelLabel.text = String(userData?.cursus_users[0]?.level ?? 0.0)
        profileProgressBar.progress = lvlProgressRest
        profileWalletLabel.text = String("Wallet: \(userData?.wallet ?? 0)₳")
        profileCorrectionLabel.text = String("Evaluation Poins: \(userData?.correction_point ?? 0)")
        profileGradeLabel.text = String("Grade: \(userData?.cursus_users[0]?.grade ?? "no grade")")
        profileEmailLabel.text = userData?.email
        profileCampusLabel.text = String("\(userData?.campus[0]?.city ?? "none"), \(userData?.campus[0]?.country ?? "none")")
//        profilePhoneLabel.text = String("Phone: \(userData?. ?? "none")")
        profileCoalitionLabel.text = String("Coalition: \(myInfo.coalitionInfo?.name ?? "none")")
        profileExamsLabel.text = String("Exams passed: \(String(self.myInfo.examsPassed)) of 5")
        profileInternLabel.text = String("Internships: \(String(self.myInfo.internPassed)) of 2")
    }
    
    func setFramesForElems() {
        projectsMoreButton.layer.borderWidth = 1.0
        projectsMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
    }
    
    func getInProgressProjects() {
        let userInfo = self.myInfo.profileInfo!
        
        for i in 0..<userInfo.projects_users.count {
            if userInfo.projects_users[i]?.status == "in_progress" {
                self.inProgressProjects.append(userInfo.projects_users[i])
                self.projectsNum += 1
            }
        }
//        print(inProgressProjects)
    }
    
    
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.projectsTableView {
            return self.projectsNum
        }
        else if tableView == self.skillsTableView {
            return (self.myInfo?.profileInfo?.cursus_users[0]?.skills.count ?? 0)
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfo = self.myInfo.profileInfo!
    
        if tableView == self.projectsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
            cell.projectNameLabel.text = inProgressProjects[indexPath.row]?.project?.name
            cell.tag = inProgressProjects[indexPath.row]?.project?.id ?? 0
            return cell
        }
        else if tableView == self.skillsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as! SkillsTableViewCell
            cell.skillNameLabel.text = userInfo.cursus_users[0]?.skills[indexPath.row]?.name
            cell.skillLevelLabel.text = String(userInfo.cursus_users[0]?.skills[indexPath.row]?.level ?? 0)
            cell.skillProgressBar.progress = Float((userInfo.cursus_users[0]?.skills[indexPath.row]?.level ?? 0) / 21)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.projectsTableView {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "projectInfo") as? SingleProjectViewController {
                vc.projectInfo = self.inProgressProjects[indexPath.row]
                vc.token = self.myInfo.tokenJson!["access_token"] as? String
                vc.projectsInfo = self.myInfo.profileInfo?.projects_users as? [Projects]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
