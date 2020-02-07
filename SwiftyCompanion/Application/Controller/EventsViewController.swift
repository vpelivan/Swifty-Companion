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
    var events: [Event?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
    }
    var startDay: String?
    var startMonth: String?
    var duration: String?
    var status: String?
    var when: String?
    var eventsUsers: [EventsUser?] = []
    let userId = AuthUser.shared.userID!
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        eventLoadIndicator.isHidden = false
        eventLoadIndicator.startAnimating()
        eventsTableView.tableFooterView = UIView(frame: .zero)
        let intraURL = AuthUser.shared.intraURL
        guard let eventsUrl = URL(string: "\(intraURL)v2/campus/8/events?filter[future]=true") else { return }
        NetworkService.shared.getData(into: [Event?].self, from: eventsUrl) { (events, result) in
            self.events = events as! [Event?]

            
            DispatchQueue.main.async {
                self.eventLoadIndicator.isHidden = true
                self.eventLoadIndicator.stopAnimating()
                self.eventsTableView.dataSource = self
                self.eventsTableView.delegate = self
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
        startDay = dayFormatter.string(from: startDate)
        startMonth = monthFormatter.string(from: startDate)
        when = whenFormatter.string(from: startDate)

        let difference = Calendar.current.dateComponents([.hour, .minute], from: startDate, to: endDate)
        let formattedHourString = String(format: "%02ld hour(s)", difference.hour!)
        let formattedMinuteString = String(format: "%02ld minute(s)", difference.minute!)
        duration = (difference.minute == 0 ? "\(formattedHourString)" : "\(formattedHourString) & \(formattedMinuteString)")
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
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.getColor()
        self.getDates(for: indexPath.row)
        cell.dateNumberLabel.text = startDay
        cell.dateMonthLabel.text = startMonth
        cell.whenLabel.text = "At: \(when ?? "--:--")"
        cell.howLongLabel.text = duration
        cell.eventNameLabel.text = events[indexPath.row]?.kind?.replacingOccurrences(of: "_", with: " ").capitalized
        guard let eventID = events[indexPath.row]?.id else { return cell }
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(self.userId)/events_users?filter[event_id]=\(eventID)") else { return cell }
        NetworkService.shared.getData(into: [EventsUser?].self, from: url) { (data, result) in
            guard let trueEventsUsers = data as? [EventsUser?] else { return }
            self.eventsUsers = trueEventsUsers
            for event in self.eventsUsers {
                if event?.eventID == eventID {
                    DispatchQueue.main.async {
                        cell.eventStatusLabel.isHidden = false
                        cell.eventStatusLabel.text = "REGISTERED"
                    }
                    break
                }
            }
        }
        cell.descriptionLabel.text = self.events[indexPath.row]?.name
        cell.locationLabel.text = self.events[indexPath.row]?.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
