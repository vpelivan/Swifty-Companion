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
            print(self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventLoadIndicator.isHidden = false
        eventLoadIndicator.startAnimating()
        let intraURL = AuthUser.shared.intraURL
        guard let url = URL(string: "\(intraURL)v2/campus/8/events?filter[future]=true") else { return }
        eventsTableView.tableFooterView = UIView(frame: .zero)
        EventsNeworkSevice.shared.getEvents(from: url) { events in
            DispatchQueue.main.async {
                self.eventLoadIndicator.isHidden = true
                self.eventLoadIndicator.stopAnimating()
                self.events = events
                print(self.events)
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
        let formattedString = String(format: "%02ld %02ld", difference.hour!, difference.minute!)
        print(formattedString)

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
        cell.eventNameLabel.text = events[indexPath.row]?.kind?.capitalized
        cell.descriptionLabel.text = self.events[indexPath.row]?.name
        cell.locationLabel.text = self.events[indexPath.row]?.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
