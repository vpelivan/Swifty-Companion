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
    var allComposedSlots: [ComposedSlot?] = []
    var scaleTeams: [Evaluation?] = []
    var slotsByDay: [SlotsOfOneDay?] = []
    var sessionTasks: [URLSessionDataTask?] = []
    var count = 0
    
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
                self.getAllComposedSlots()
                self.getSlotsByDay()
//                for slot in self.allComposedSlots {
//                    print(slot?.beginAt ?? 0)
//                    print(slot?.endAt ?? 0)
//                    print("")
//                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
            }
        }
    }
    
    func isOneDay(from oneDay: Date?, with secondDay: Date?) -> (Bool, Date?) {
        guard let oneDay = oneDay, let secondDay = secondDay else { return (false, nil) }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let one = dateFormatter.string(from: oneDay)
        let two = dateFormatter.string(from: secondDay)
        if one == two {
            return (true, oneDay)
        } else {
            return (false, secondDay)
        }
    }
    
    func getSlotsByDay() {
        for slot in allComposedSlots {
            if slotsByDay.isEmpty == true {
                var singleDay: SlotsOfOneDay? = SlotsOfOneDay(slots: [nil])
                let tuple = isOneDay(from: slot?.beginAt, with: slot?.beginAt)
                singleDay?.date = tuple.1
                singleDay?.slots.append(slot)
                slotsByDay.append(singleDay)
            } else {
                guard var last = slotsByDay.last else { break }
                let tuple = isOneDay(from: last?.date, with: slot?.beginAt)
                if tuple.0 == true {
                    last?.slots.append(slot)
                    
                } else {
                    var singleDay: SlotsOfOneDay? = SlotsOfOneDay(slots: [nil])
                    singleDay?.date = tuple.1
                    singleDay?.slots.append(slot)
                    slotsByDay.append(singleDay)
                    continue
                }
            }
        }
    }
    
    
// MARK: - We gather all slots of 15 minutes interval to an array of composed slots with a duration
    func getAllComposedSlots() {
        while count < allSlots.count {
            let composedSlot = getSingleComposedSlot()
            allComposedSlots.append(composedSlot)
        }
    }
// MARK: - We gather single composed slot of neighbour slots with 15 minutes duaration
    func getSingleComposedSlot() -> ComposedSlot? {
        var composedSlot: ComposedSlot? = ComposedSlot(slotArray: [nil])
        let localTime = OtherMethods.shared.convertToLocalDate
        
        for i in stride(from: count, to: allSlots.count, by: 1)  {
            guard let currentSlot = allSlots[i] else { break }
            if i == count {
                composedSlot?.beginAt = localTime(currentSlot.beginAt)
                composedSlot?.slotArray.append(currentSlot)
                composedSlot?.endAt = localTime(currentSlot.endAt)
            }
            if (i != allSlots.count - 1) {
                guard let nextSlot = allSlots[i + 1] else { count = i + 1; break }
                if currentSlot.endAt == nextSlot.beginAt {
                    composedSlot?.slotArray.append(nextSlot)
                    composedSlot?.endAt = localTime(nextSlot.endAt)
                } else {
                    count = i + 1
                    return composedSlot
                }
            }
        }
        count = allSlots.count
        return composedSlot
    }
}

extension SlotsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return slotsByDay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slotsByDay[section]?.slots.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return OtherMethods.shared.getDay(from: slotsByDay[section]?.date)
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
