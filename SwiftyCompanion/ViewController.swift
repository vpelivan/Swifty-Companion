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
    
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchTableView = storyboard!.instantiateViewController(withIdentifier: "SearchTableView") as! SearchTableView
        searchController = UISearchController(searchResultsController: searchTableView)
        searchController?.searchBar.placeholder = "Search user"
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    @IBAction func tapSearch(_ sender: UIBarButtonItem) {
        print("1")
        searchController?.searchBar.becomeFirstResponder()
    }
    
}

