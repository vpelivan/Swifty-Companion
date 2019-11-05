//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 10/25/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var projectsMoreButton: UIButton!
    @IBOutlet weak var skillsMoreButton: UIButton!
    @IBOutlet weak var evalMoreButton: UIButton!
    @IBOutlet weak var eventsMoreButton: UIButton!
    @IBOutlet weak var evalView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var profileViewConstr: NSLayoutConstraint!
    var searchController: UISearchController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setFramesForElems()
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

