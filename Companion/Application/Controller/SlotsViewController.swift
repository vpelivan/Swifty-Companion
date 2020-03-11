//
//  SlotsViewController.swift
//  Companion
//
//  Created by Victor Pelivan on 3/5/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SlotsViewController: UIViewController {
    
    @IBOutlet weak var notSetLabel: UILabel!
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
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notSetLabel.isHidden = true
        self.slotsByDay = []
        tableView.reloadData()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        parseSlots()
    }
    
    func parseSlots() {
        DispatchQueue.global().async {
            self.allSlots = []
            let group = DispatchGroup()
            var flag = false
            for i in 1... {
                group.enter()
                if i != 0 && i % 2 == 0 {
                    sleep(1)
                }
                let task = self.getSlotsData(num: i) { slots in
                    if slots.isEmpty == false {
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
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.count = 0
                self.getAllComposedSlots()
                self.getSlotsByDay()
                if self.slotsByDay.isEmpty == true {
                    self.notSetLabel.isHidden = false
                }
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                group.leave()
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
        self.slotsByDay = []
        for i in 0 ..< allComposedSlots.count {
            guard let slot = allComposedSlots[i] else { return }
            if slotsByDay.isEmpty == true {
                var singleDay: SlotsOfOneDay? = SlotsOfOneDay(slots: [])
                let tuple = isOneDay(from: slot.beginAt, with: slot.beginAt)
                singleDay?.date = tuple.1
                singleDay?.slots.append(slot)
                slotsByDay.append(singleDay)
            } else {
                guard let lastElementDate = slotsByDay.last??.date else { break }
                let tuple = isOneDay(from: lastElementDate, with: slot.beginAt)
                if tuple.0 == true {
                    slotsByDay[slotsByDay.endIndex - 1]?.slots.append(slot)
                } else {
                    var singleDay: SlotsOfOneDay? = SlotsOfOneDay(slots: [])
                    singleDay?.date = tuple.1
                    singleDay?.slots.append(slot)
                    slotsByDay.append(singleDay)
                }
            }
        }
    }
    
    @IBAction func tapPlus(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "NewSlotViewController", sender: nil)
    }
    
// MARK: - We gather all slots of 15 minutes interval to an array of composed slots with a duration
    func getAllComposedSlots() {
        self.allComposedSlots = []
        while count < allSlots.count {
            let composedSlot = getSingleComposedSlot()
            allComposedSlots.append(composedSlot)
        }
    }
// MARK: - We gather single composed slot of neighbour slots with 15 minutes duaration
    func getSingleComposedSlot() -> ComposedSlot? {
        var composedSlot: ComposedSlot? = ComposedSlot(slotArray: [])
        let getDate = OtherMethods.shared.getDate
        
        for i in stride(from: count, to: allSlots.count, by: 1)  {
            guard let currentSlot = allSlots[i] else { break }
            
            if i == count {
                composedSlot?.beginAt = getDate(currentSlot.beginAt, "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                composedSlot?.slotArray.append(currentSlot)
                composedSlot?.endAt = getDate(currentSlot.endAt, "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                
            }
            if (i != allSlots.count - 1) {
                guard let nextSlot = allSlots[i + 1] else { count = i + 1; break }
                if currentSlot.endAt == nextSlot.beginAt {
                    composedSlot?.slotArray.append(nextSlot)
                    composedSlot?.endAt = getDate(nextSlot.endAt, "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
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
        guard let beginDate = self.slotsByDay[indexPath.section]?.slots[indexPath.row]?.beginAt else { return UITableViewCell() }
        guard let endDate = self.slotsByDay[indexPath.section]?.slots[indexPath.row]?.endAt else { return UITableViewCell() }
        let getHours = OtherMethods.shared.getHours
        cell.timeLabel.text = "\(getHours(beginDate)) - \(getHours(endDate))"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nvc = segue.destination as? NewSlotViewController else { return }
        nvc.allComposedSlots = self.allComposedSlots
    }
}

extension SlotsViewController {
    func getSlotsData(num: Int, completion: @escaping ([Slot?]) -> ()) -> URLSessionDataTask? {
        guard let token = AuthUser.shared.token?.accessToken else { return nil }
        let intraURL = AuthUser.shared.intraURL
        let url = URL(string: "\(intraURL)/v2/me/slots?page[size]=100&filter[future]=true&page[number]=\(num)&sort=begin_at,scale_team_id")
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

