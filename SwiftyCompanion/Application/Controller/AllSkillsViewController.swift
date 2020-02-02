//
//  AllSkillsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/26/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class AllSkillsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var skills: [Skill]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    

}

extension AllSkillsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as! SkillsTableViewCell
        if let skillName = skills[indexPath.row].name {
            cell.skillNameLabel.text = skillName
        }
        cell.skillLevelLabel.text = String(self.skills[indexPath.row].level ?? 0)
        cell.skillProgressBar.progress = Float((self.skills[indexPath.row].level ?? 0) / 21)
        return cell
    }
}
