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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension NewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! NewCellController
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CursusCell", for: indexPath) as! NewCursusCell
            return cell
        }
        return UITableViewCell()
    }
}
