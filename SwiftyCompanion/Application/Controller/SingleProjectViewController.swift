//
//  SingleProjectViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/22/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SingleProjectViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var of100Label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var colorCyan = UIColor(red: 82.0/255.0, green: 183.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    var colorRed = UIColor(red: 223.0/255.0, green: 134.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    var colorGreen = UIColor (red: 115.0/255.0, green: 182.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    var projectInfo: Projects!
    var projectsInfo: [Projects]!
    var neededProjects: [Projects] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(projectInfo!)
        navigationItem.title = projectInfo.project?.name
        getPoolDays()
        fetchProjectInfo()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func getPoolDays() {
            for i in 0..<projectsInfo.count {
                if projectInfo.project?.id == projectsInfo[i].project?.parent_id {
                    neededProjects.append(projectsInfo[i])
                }
            }
        print(neededProjects)
    }
    
    func fetchProjectInfo() {
        if projectInfo.status == "in_progress" || projectInfo.status == "searching_a_group" {
            statusLabel.text = "subscribed"
            markView.backgroundColor = colorCyan
            markLabel.isHidden = true
            of100Label.isHidden = true
            imageView.isHidden = false
        } else if projectInfo.status == "finished" {
            if projectInfo.validated == 1 {
                statusLabel.text = "success"
                markView.backgroundColor = colorGreen
                markLabel.isHidden = false
                of100Label.isHidden = false
                imageView.isHidden = true
                markLabel.text = String(projectInfo.final_mark ?? 0)
            } else {
                statusLabel.text = "fail"
                markView.backgroundColor = colorRed
                markLabel.isHidden = false
                of100Label.isHidden = false
                imageView.isHidden = true
                markLabel.text = String(projectInfo.final_mark ?? 0)
            }
        }
        
        
//        markLabel.text = String(projectInfo.final_mark)
    }

}

extension SingleProjectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return neededProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PooldDaysCell", for: indexPath) as! PoolDayTableViewCell
        cell.dayName.text = neededProjects[indexPath.row].project?.name
        cell.dayStatus.text = String(neededProjects[indexPath.row].final_mark ?? 0)
        if neededProjects[indexPath.row].validated == 1 {
            cell.dayStatus.textColor = colorGreen
            cell.dayName.textColor = colorGreen
        } else {
            cell.dayStatus.textColor = colorRed
            cell.dayName.textColor = colorRed
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
