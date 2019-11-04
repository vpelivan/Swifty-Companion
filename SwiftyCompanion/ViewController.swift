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
    @IBOutlet weak var nameInfoView: UIView!
    @IBOutlet weak var levelInfoView: UIView!
    @IBOutlet weak var diffInfoView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var coalitionImageView: UIImageView!
    
    
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
    
    func setFramesForElems() {
        projectsMoreButton.layer.borderWidth = 1.0
        projectsMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
        skillsMoreButton.layer.borderWidth = 1.0
        skillsMoreButton.layer.borderColor = (UIColor(red: 77.0/255.0, green: 173.0/255.0, blue: 176.0/255.0, alpha: 1.0)).cgColor
//        nameInfoView.layer.cornerRadius = 5.0
//        levelInfoView.layer.cornerRadius = 5.0
//        diffInfoView.layer.cornerRadius = 5.0
//        photoImageView.layer.cornerRadius = 5.0
    }
    
}

