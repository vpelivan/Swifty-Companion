//
//  EventsViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/26/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var eventsTableView: UITableView!
    var events: [Event?] = [] {
        didSet {
            print(self)
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let intraURL = AuthUser.shared.intraURL
        guard let url = URL(string: "\(intraURL)v2/campus/8/events?filter[future]=true") else { return }
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.tableFooterView = UIView(frame: .zero)
        EventsNeworkSevice.shared.getEvents(from: url) { events in
            self.events = events
            print(self.events)
        }
    }
    
    func getDateFormat(from date: String?) -> String {
         let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:000'Z'"
             
        guard let beginDate = dateFormatter.date(from: date!) else { return "-"}
        guard let month = Calendar.current.dateComponents([.month], from: beginDate).month else {return "-"}
        let duration = String(month) + "h"
        return(duration)
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.getColor()
        print(getDateFormat(from: self.events[indexPath.row]?.beginAt))
        cell.eventNameLabel.text = events[indexPath.row]?.kind?.capitalized
        cell.descriptionLabel.text = self.events[indexPath.row]?.name
        cell.locationLabel.text = self.events[indexPath.row]?.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
