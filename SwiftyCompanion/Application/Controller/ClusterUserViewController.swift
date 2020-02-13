//
//  ClusterUserViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/11/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ClusterUserViewController: UITableViewController {

    @IBOutlet weak var userViewPicture: UIImageView!
    @IBOutlet weak var userViewLogin: UILabel!
    @IBOutlet weak var userViewLocation: UILabel!
    @IBOutlet weak var userViewBeginSess: UILabel!
    @IBOutlet weak var userViewSessTime: UILabel!
    var login: String?
    var location: String?
    var beginSess: String?
    var sessTime: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(login ?? "User")"
        tableView.tableFooterView = UIView(frame: .zero)
        guard let url = URL(string: "https://cdn.intra.42.fr/users/\(login ?? "").jpg") else { return }
        userViewPicture.kf.setImage(with: url)
        userViewLocation.text = location
        userViewLogin.text = login
        userViewBeginSess.text = beginSess
        userViewSessTime.text = sessTime
        tableView.reloadData()
    }

    @IBAction func tapViewProfile(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toProfileViewController", sender: nil)
        }
    }
    
    
}
