//
//  SingleEventViewController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/26/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class SingleEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDatelabel: UILabel!
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventWhenLabel: UILabel!
    @IBOutlet weak var eventDurationLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventPeopleCounterLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIBarButtonItem!
    
    
    var event: Event?
    var startDay: String?
    var startMonth: String?
    var duration: String?
    var status: String?
    var when: String?
    var unsubscribeID: Int?
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    let colorRed = #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        fetchEventData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            performSegue(withIdentifier: "unwindToEventsViewController", sender: nil)
        }
    }
    
    @IBAction func tapSubscribe(_ sender: UIBarButtonItem) {
        if status == "REGISTERED" {
            guard let trueId = unsubscribeID else { return }
            let alert = UIAlertController(title: "Unsubscribe from event", message: nil, preferredStyle: .actionSheet)
            let unsubscribe = UIAlertAction(title: "Unsubscribe", style: .default, handler: { _ in
                EventsNeworkSevice.shared.unsubscribeFromEvent(with: trueId, completion: {
                    DispatchQueue.main.async {
                        self.eventStatusLabel.isHidden = true
                        self.subscribeButton.title = "Subscribe"
                        self.subscribeButton.tintColor = self.colorCyan
                        self.status = ""
                    }
                })
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                return
            })
            alert.addAction(unsubscribe)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        } else {
            guard let id = event?.id, let userID = AuthUser.shared.userID else { return }
            let alert = UIAlertController(title: "Subscribe to event", message: nil, preferredStyle: .actionSheet)
            let subscribe = UIAlertAction(title: "Subscribe", style: .default, handler: { _ in
                EventsNeworkSevice.shared.subscribeToEvent(eventID: id, userID: userID, completion: {
                    DispatchQueue.main.async {
                        self.eventStatusLabel.isHidden = false
                        self.subscribeButton.title = "Unsubscribe"
                        self.subscribeButton.tintColor = self.colorRed
                        self.status = "REGISTERED"
                    }
                })
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                return
            })
            alert.addAction(subscribe)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func fetchEventData() {
        if status == "REGISTERED" {
            eventStatusLabel.isHidden = false
            subscribeButton.title = "Unsubscribe"
            subscribeButton.tintColor = colorRed
        }
        eventTypeLabel.text = event?.kind?.capitalized.replacingOccurrences(of: "_", with: " ")
        eventNameLabel.text = event?.name
        eventDatelabel.text = OtherMethods.shared.getDateAndTime(from: event?.beginAt)
        eventWhenLabel.text = when
        eventDurationLabel.text = duration
        eventLocationLabel.text = event?.location
        eventPeopleCounterLabel.text = "\(event?.nbrSubscribers ?? 0)/\(event?.maxPeople ?? 0)"
    }
}

extension SingleEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! SingleEventDescriptionCell
        cell.descriptionLabel.text = event?.eventDescription
        return cell
    }
    
    
}
