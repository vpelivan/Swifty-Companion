//
//  EvaluationsViewController.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/23/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class EvaluationsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var evaluations: [Evaluation?] = []
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    let intraURL = AuthUser.shared.intraURL
    var login: String?
    var sessionTasks: [URLSessionDataTask?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.tableView.reloadData()
        fetchData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if sessionTasks.isEmpty == false {
            for task in sessionTasks {
                guard let trueTask = task else { continue }
                if trueTask.state == .running {
                    trueTask.cancel()
                }
            }
        }
    }
        
    fileprivate func fetchData() {
        guard let correctorUrl = URL(string: "\(intraURL)v2/me/scale_teams/as_corrector") else { return }
        guard let correctedUrl = URL(string: "\(intraURL)v2/me/scale_teams/as_corrected") else { return }
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            group.enter()
            let correctorTask = NetworkService.shared.getDataWithoutAlarm(into: [Evaluation?].self, from: correctorUrl) { (evaluations, result) in
                guard let trueEval = evaluations as? [Evaluation?] else { return }
                self.evaluations = trueEval
                print("corrector")
                group.leave()
            }
            self.sessionTasks.append(correctorTask)
            group.wait()
            group.enter()
            let correctedTask = NetworkService.shared.getDataWithoutAlarm(into: [Evaluation?].self, from: correctedUrl) { (evaluations, result) in
                guard let trueEval = evaluations as? [Evaluation?] else { return }
                for eval in trueEval {
                    self.evaluations.append(eval)
                }
                print("corrected")
                group.leave()
            }
            self.sessionTasks.append(correctedTask)
            group.wait()
            
            for i in 0 ..< self.evaluations.count {
                sleep(1)
                group.enter()
                if self.evaluations.isEmpty == false {
                    guard let projectID = self.evaluations[i]?.team?.projectID else { continue }
                    guard let projectUrl = URL(string: "\(self.intraURL)/v2/projects/\(projectID)") else { continue }
                    let nameTask = NetworkService.shared.getDataWithoutAlarm(into: ProjectName?.self, from: projectUrl) { (project, result) in
                        guard let trueProject = project as? ProjectName else { return }
                        self.evaluations[i]?.projectName = trueProject.name
                        print("project name")
                        group.leave()
                    }
                    self.sessionTasks.append(nameTask)
                }
                else {
                    group.leave()
                }
            }
            group.wait()
            group.enter()
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                group.leave()
            }
        }
    }
    
    fileprivate func fetchTime(from date: String?) -> (String, Bool) {
        let date = OtherMethods.shared.getDateAndTime(from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        guard let formattedDate = dateFormatter.date(from: date) else { return ("-", true) }
        let evalInterval = formattedDate.timeIntervalSince1970
        let nowInterval = Date().timeIntervalSince1970
        let difference = Int((evalInterval - nowInterval))
        
        switch difference {
        case Int.min ... -129601: return (" \((difference / 86400) * -1) day(s) ago", false)
        case -129600 ..< -86400: return (" one day ago", false)
        case -86400 ..< -4200: return (" \((difference / 3600) * -1) hour(s) ago", false)
        case -4200 ..< -3555: return (" one hour ago", false)
        case -3555 ..< 180: return (" \((difference / 60) * -1) minute(s) ago", false)
        case -180 ..< -60: return (" a few minutes ago", false)
        case -60 ..< -30: return (" a minute ago", false)
        case -30 ..< 0: return (" a few seconds ago", false)
        case 0 ..< 30: return (" in a few seconds", true)
        case 30 ..< 60: return (" in a minute", true)
        case 60 ..< 180: return (" in a few minutes", true)
        case 180 ..< 3555: return (" in \(difference / 60) minute(s)", true)
        case 3555 ..< 4200: return (" in one hour", true)
        case 4200 ..< 86400: return (" in \(difference / 3600) hour(s)", true)
        case 86400 ..< 129600: return (" in one day", true)
        case 129600...Int.max : return (" in \(difference / 86400) day(s)", true)
        default: return ("-", true)
        }
    }
    
    @objc func viewProfile(_ sender: UIButton) {
        login = sender.currentTitle
        self.performSegue(withIdentifier: "toProfileFromEval", sender: nil)
    }
}

extension EvaluationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityIndicator.isHidden == false {
            return 0
        }
        return evaluations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "evalCell", for: indexPath) as! EvaluationViewCell
        let tuple = fetchTime(from: evaluations[indexPath.row]?.beginAt)
        cell.loginButton.isHidden = false
        cell.projectLabel.isHidden = false
        if evaluations[indexPath.row]?.corrector?.visible?.id == AuthUser.shared.userID {
            if let corrected = evaluations[indexPath.row]?.correcteds?.visible {
                if corrected.isEmpty == false {
                    if tuple.1 == true {
                        cell.willEvaluate.text = "You will evaluate: "
                    } else {
                        cell.willEvaluate.text = "You're supposed to evaluate: "
                    }
                    cell.loginButton.setTitle(corrected[0]?.login, for: .normal)
                    cell.loginButton.addTarget(self, action: #selector(EvaluationsViewController.viewProfile(_:)), for: .touchUpInside)
                }
            } else {
                cell.willEvaluate.text = "You will evaluate someone"
                cell.loginButton.isHidden = true
                cell.projectLabel.isHidden = true
            }
            cell.timeLabel.text = tuple.0
            cell.projectLabel.text = "on \(evaluations[indexPath.row]?.projectName ?? "-")"
        } else {
            if tuple.1 == true {
                cell.willEvaluate.text = "You will be evaluated by: "
            } else {
                cell.willEvaluate.text = "You're supposed to be evaluated by: "
            }
            if let corrector = evaluations[indexPath.row]?.corrector?.visible?.login {
                cell.loginButton.setTitle(corrector, for: .normal)
                cell.loginButton.addTarget(self, action: #selector(EvaluationsViewController.viewProfile(_:)), for: .touchUpInside)
            } else {
                cell.willEvaluate.text = "You will be evaluated by someone"
                cell.loginButton.isHidden = true
            }
            cell.timeLabel.text = tuple.0
            cell.projectLabel.text = "on \(evaluations[indexPath.row]?.projectName ?? "-")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let scaleTeamsID = evaluations[indexPath.row]?.id else { return UISwipeActionsConfiguration() }
        let deleteAction = UIContextualAction(style: .destructive, title: "Skip Evaluation") {  (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "Skip Evaluation", message: nil, preferredStyle: .actionSheet)
            let skip = UIAlertAction(title: "Skip", style: .default, handler: { _ in
                EvalNetworkSevice.shared.skipEvaluation(with: scaleTeamsID) {
                    DispatchQueue.main.async {
                        self.evaluations.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        print("Skipped evaluation")
                    }
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                return
            })
            alert.addAction(skip)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}
