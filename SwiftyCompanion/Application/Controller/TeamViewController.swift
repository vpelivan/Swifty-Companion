//
//  TeamViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 12/2/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Some Text"
        makeDataRequest()
        // Do any additional setup after loading the view.
    }
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
        return cell
    }
    
}

extension TeamViewController {
    func makeDataRequest() {
        let token = AuthUser.shared.tokenJson
        let intraURL = AuthUser.shared.intraURL
        guard let url = URL(string: "\(intraURL)/v2/project_sessions/1060/evaluations") else { return }
        
    }
}
