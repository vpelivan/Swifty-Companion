//
//  SlotsViewController.swift
//  Companion
//
//  Created by Victor Pelivan on 3/5/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SlotsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var allSlots: [Slot?] = []
    var scaleTeams: [Evaluation?] = []
    var slotsByDay: [Slots?] = []
    var sessionTasks: [URLSessionDataTask?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        parseSlots()
    }
    
    func parseSlots() {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            var flag = false
            for i in 1... {
                group.enter()
                if i != 0 && i % 2 == 0 {
                    sleep(1)
                }
                let task = self.getSlotsData(num: i) { slots in
                    if slots.isEmpty == false {
                        print(slots)
                        self.allSlots += slots
                    }
                    else {
                        flag = true
                    }
                    group.leave()
                }
                group.wait()
                if flag == true {
                    break
                }
                self.sessionTasks.append(task)
            }
            group.enter()
//            self.getSlotsByDay()
            group.leave()
            DispatchQueue.main.async {
                guard let currentEnd = self.allSlots[0]?.endAt else {return}
                guard let nextBegin = self.allSlots[1]?.beginAt else {return}
                let i = self.isOneSlot(from: currentEnd, to: nextBegin)
                print(i ?? 0)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
            }
        }
    }
    
    //        if allSlots.count > 1 {
    //            for i in 0 ..< allSlots.count {
    //                guard let currentSlot = allSlots[i] else { break }
    //                guard let nextSlot = allSlots[i + 1] else { break }
    //                if currentSlot.endAt == nextSlot.beginAt {
    //
    //
    //                } else {
    //
    //                }
    //            }
    //        } else {
    //            guard let currentSlot = allSlots[0] else { break }
    //            var composedSlot: ComposedSlot?
    //            composedSlot?.slotArray.append(currentSlot)
    //            composedSlot?.beginAt = currentSlot.beginAt
    //            composedSlot?.endAt = currentSlot.endAt
    //        }
    //    }
    
    func isOneSlot(from currentSlotEnd: String?, to nextSlotBegin: String?) -> Bool? {
        guard let currentSlot = currentSlotEnd, let nextSlot = nextSlotBegin else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        dateFormatter.timeZone = .current
        if let current = dateFormatter.date(from: currentSlot), let next = dateFormatter.date(from: nextSlot) {
            if current == next {
                return true
            }
            else {
                return false
            }
        }
        return nil
    }
    
//    func getSlotsByDay() {
//        for slot in allSlots {
//
//        }
//    }
    
    func getComposedSlots() {
        
    }
}

extension SlotsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCell", for: indexPath) as! SlotsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete Slot") {  (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "Delete Slot", message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                
                DispatchQueue.main.async {
//                    self.evaluations.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    print("Slot Deleted")
                }
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                return
            })
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

extension SlotsViewController {
    func getSlotsData(num: Int, completion: @escaping ([Slot?]) -> ()) -> URLSessionDataTask? {
        guard let token = AuthUser.shared.token?.accessToken else { return nil }
        let intraURL = AuthUser.shared.intraURL
        let url = NSURL(string: "\(intraURL)/v2/me/slots?page[size]=100&filter[future]=true&page[number]=\(num)&sort=begin_at,scale_team_id")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            print(num)
            do
            {
                guard let data = data else { return }
                let slots = try JSONDecoder().decode([Slot?].self, from: data)
                completion(slots)
            }
            catch let error {
                completion([Slot?]())
                return print("Another error:\(error)")
            }
        }
        task.resume()
        return task
    }
}
