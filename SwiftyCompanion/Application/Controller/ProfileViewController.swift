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
    @IBOutlet weak var skillsMoreButton: UIButton!
    @IBOutlet weak var evalMoreButton: UIButton!
    @IBOutlet weak var eventsMoreButton: UIButton!
    @IBOutlet weak var evalView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var profileViewConstr: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileSurnameLabel: UILabel!
    @IBOutlet weak var profileLoginLabel: UILabel!
    @IBOutlet weak var profileCampusLabel: UILabel!
    @IBOutlet weak var profileAdressLabel: UILabel!
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
    
    
    var searchController: UISearchController?
    
    var myInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setFramesForElems()
        fetchUserData()
//        print(self.myInfo.projectsInfo?.final_mark ?? 0)
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
        profileAdressLabel.text = String("\(userData?.campus[0]?.address ?? "none")")
        profileCoalitionLabel.text = String("Coalition: \(myInfo.coalitionInfo?.name ?? "none")")
        profileExamsLabel.text = String("Exams passed: \(String(self.myInfo.examsPassed)) of 5")
        profileInternLabel.text = String("Internships: \(String(self.myInfo.internPassed)) of 2")
    }
    
    func hideEnableViews() { // enables and hides evaluations and events views, needed if a user is searching not for his profile
        if evalView.isHidden == false {
            evalView.isHidden = true
            eventsView.isHidden = true
            profileViewConstr.constant = 500
        } else {
            evalView.isHidden = false
            eventsView.isHidden = false
            profileViewConstr.constant = 988
        }
    }
    
    func setFramesForElems() {
        projectsMoreButton.layer.borderWidth = 1.0
        projectsMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
        skillsMoreButton.layer.borderWidth = 1.0
        skillsMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
        eventsMoreButton.layer.borderWidth = 1.0
        eventsMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
        evalMoreButton.layer.borderWidth = 1.0
        evalMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
    }
}

