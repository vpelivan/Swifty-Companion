//
//  EventsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/26/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import Foundation

class EventsViewController: UIViewController {
    
    @IBOutlet weak var eventLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventsTableView: UITableView!
    var events: [Event?] = []
    var eventsData: [EventsData?] = []
    var eventsUsers: [EventsUser?] = []
    let userId = AuthUser.shared.userID!
    let campusId = AuthUser.shared.campusID!
    var selectedIndexPath: IndexPath?
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var sessionTasks: [URLSessionDataTask?] = []
    @IBOutlet weak var noEventsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        eventsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noEventsLabel.isHidden = true
        eventLoadIndicator.isHidden = false
        eventLoadIndicator.startAnimating()
        performRequest()
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
    
    func performRequest() {
        let intraURL = AuthUser.shared.intraURL
        guard let eventsUrl = URL(string: "\(intraURL)v2/campus/\(campusId)/events?filter[future]=true") else { return }
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(self.userId)/events_users") else { return }
        DispatchQueue.global().async{
            let group = DispatchGroup()
            group.enter()
            let eventsTask = NetworkService.shared.getDataWithoutAlarm(into: [Event?].self, from: eventsUrl) { (events, result) in
                guard let eventsForSure = events as? [Event?] else { return }
                self.events = eventsForSure
                for _ in 0..<self.events.count {
                    self.eventsData.append(EventsData())
                }
                group.leave()
            }
            self.sessionTasks.append(eventsTask)
            group.wait()
            group.enter()
            let userTask = NetworkService.shared.getDataWithoutAlarm(into: [EventsUser?].self, from: url) { (data, result) in
                guard let trueEventUsers = data as? [EventsUser?] else { return }
                self.eventsUsers = trueEventUsers
                group.leave()
            }
            self.sessionTasks.append(userTask)
            group.wait()
            group.enter()
            DispatchQueue.main.async {
                self.eventLoadIndicator.isHidden = true
                self.eventLoadIndicator.stopAnimating()
                self.eventsTableView.reloadData()
                self.eventsTableView.dataSource = self
                self.eventsTableView.delegate = self
                if self.events.count == 0 {
                    self.noEventsLabel.isHidden = false
                }
                self.eventLoadIndicator.isHidden = true
                self.eventLoadIndicator.stopAnimating()
                group.leave()
            }
        }
    }
    
    func getDates(for row: Int) {
        let startDateApi = OtherMethods.shared.getDateAndTime(from: events[row]?.beginAt)
        let endDateApi = OtherMethods.shared.getDateAndTime(from: events[row]?.endAt)
        let dateFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
        let whenFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dayFormatter.dateFormat = "dd"
        monthFormatter.dateFormat = "MMMM"
        whenFormatter.dateFormat = "h:mm a"
        let startDate = dateFormatter.date(from: startDateApi)!
        let endDate = dateFormatter.date(from: endDateApi)!
        eventsData[row]?.startDay = dayFormatter.string(from: startDate)
        eventsData[row]?.startMonth = monthFormatter.string(from: startDate)
        eventsData[row]?.when = whenFormatter.string(from: startDate)
        
        let difference = Calendar.current.dateComponents([.hour, .minute], from: startDate, to: endDate)
        let formattedHourString = String(format: "%2ld", difference.hour!)
        let formattedMinuteString = String(format: "%02ld", difference.minute!)
        eventsData[row]?.duration = (difference.minute == 0 ? "\(formattedHourString)h" : "\(formattedHourString):\(formattedMinuteString)h")
    }
    
    func getDateFormat(from date: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm.SSS'Z'"
        if var date = date {
            if let formattedDate = dateFormatter.date(from: date) {
                date = dateFormatter.string(from: formattedDate)
                return date
            }
        }
        return "-"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventVC = segue.destination as? SingleEventViewController
        guard let index = sender as? Int else { return }
        guard let event = self.events[index] else { return }
        eventsData[index]?.event = event
        eventVC?.eventData = eventsData[index]
    }
    
    @IBAction func unwindToEventsViewController(_ unwindSegue: UIStoryboardSegue) {
        
        guard let svc = unwindSegue.source as? SingleEventViewController,
            let indexPath = selectedIndexPath else { return print("error to cast svc or selectedIndexPath = nil") }
        eventsData[indexPath.row]?.status = svc.eventData?.status
        eventLoadIndicator.isHidden = false
        eventLoadIndicator.startAnimating()
        eventsTableView.reloadData()
        performRequest()
    }
}
extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventLoadIndicator.isHidden == false {
            return 0
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.getColor()
        self.getDates(for: indexPath.row)
        cell.dateNumberLabel.text = eventsData[indexPath.row]?.startDay
        cell.dateMonthLabel.text = eventsData[indexPath.row]?.startMonth
        cell.whenLabel.text = "\(eventsData[indexPath.row]?.when ?? "--:--")"
        cell.howLongLabel.text = eventsData[indexPath.row]?.duration
        cell.eventNameLabel.text = events[indexPath.row]?.kind?.replacingOccurrences(of: "_", with: " ").capitalized
        for event in self.eventsUsers {
            if event?.eventID == self.events[indexPath.row]?.id {
                cell.eventStatusLabel.isHidden = false
                self.eventsData[indexPath.row]?.status = "REGISTERED"
                cell.eventStatusLabel.text = self.eventsData[indexPath.row]?.status
                self.eventsData[indexPath.row]?.unsubscribeID = event?.id
                break
            }
        }
        cell.eventStatusLabel.text = self.eventsData[indexPath.row]?.status
        cell.descriptionLabel.text = self.events[indexPath.row]?.name
        if let location = self.events[indexPath.row]?.location {
            cell.locationLabel.text = String("\(location)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "goToSingleEvent", sender: indexPath.row)
    }
}
