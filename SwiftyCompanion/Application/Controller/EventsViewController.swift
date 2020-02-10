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
    var startDay: [String?] = []
    var startMonth: [String?] = []
    var duration: [String?] = []
    var status: [String?] = []
    var when: [String?] = []
    var unsubscribeID: [Int?] = []
    var eventsUsers: [EventsUser?] = []
    let userId = AuthUser.shared.userID!
    let campusId = AuthUser.shared.campusID!
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = colorCyan
        eventsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventLoadIndicator.isHidden = false
        eventLoadIndicator.startAnimating()
        let intraURL = AuthUser.shared.intraURL
        guard let eventsUrl = URL(string: "\(intraURL)v2/campus/\(campusId)/events?filter[future]=true") else { return }
        NetworkService.shared.getData(into: [Event?].self, from: eventsUrl) { (events, result) in
            guard let eventsForSure = events as? [Event?] else { return }
            self.events = eventsForSure
            for _ in 0..<self.events.count {
                self.status.append("")
                self.startDay.append("")
                self.startMonth.append("")
                self.duration.append("")
                self.when.append("")
                self.unsubscribeID.append(0)
            }
            guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(self.userId)/events_users") else { return }
            NetworkService.shared.getData(into: [EventsUser?].self, from: url) { (data, result) in
                guard let trueEventUsers = data as? [EventsUser?] else { return }
                self.eventsUsers = trueEventUsers
                DispatchQueue.main.async {
                    self.eventLoadIndicator.isHidden = true
                    self.eventLoadIndicator.stopAnimating()
                    self.eventsTableView.reloadData()
                    self.eventsTableView.dataSource = self
                    self.eventsTableView.delegate = self
                }
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
        startDay[row] = dayFormatter.string(from: startDate)
        startMonth[row] = monthFormatter.string(from: startDate)
        when[row] = whenFormatter.string(from: startDate)

        let difference = Calendar.current.dateComponents([.hour, .minute], from: startDate, to: endDate)
        let formattedHourString = String(format: "%2ld", difference.hour!)
        let formattedMinuteString = String(format: "%02ld", difference.minute!)
        duration[row] = (difference.minute == 0 ? "⏳: \(formattedHourString)h" : "⏳: \(formattedHourString):\(formattedMinuteString)h")
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
        eventVC?.event = event
        eventVC?.startDay = startDay[index]
        eventVC?.startMonth = startMonth[index]
        eventVC?.duration = duration[index]
        eventVC?.status = status[index]
        eventVC?.when = when[index]
        eventVC?.unsubscribeID = unsubscribeID[index]
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
        cell.dateNumberLabel.text = startDay[indexPath.row]
        cell.dateMonthLabel.text = startMonth[indexPath.row]
        cell.whenLabel.text = "🕓: \(when[indexPath.row] ?? "--:--")"
        cell.howLongLabel.text = duration[indexPath.row]
        cell.eventNameLabel.text = events[indexPath.row]?.kind?.replacingOccurrences(of: "_", with: " ").capitalized
        for event in self.eventsUsers {
            if event?.eventID == self.events[indexPath.row]?.id {
                cell.eventStatusLabel.isHidden = false
                self.status[indexPath.row] = "REGISTERED"
                cell.eventStatusLabel.text = self.status[indexPath.row]
                self.unsubscribeID[indexPath.row] = event?.id
                break
            }
        }
        cell.descriptionLabel.text = self.events[indexPath.row]?.name
        cell.locationLabel.text = String("📍: \(self.events[indexPath.row]?.location ?? "")")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToSingleEvent", sender: indexPath.row)
    }
}
