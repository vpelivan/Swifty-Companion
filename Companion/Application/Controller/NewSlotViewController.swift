//
//  NewSlotViewController.swift
//  Companion
//
//  Created by Viktor PELIVAN on 3/10/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit

class NewSlotViewController: UIViewController {

    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStartDatePicker()
        setEndDatePicker()
    }
    
    func setStartDatePicker() {
        startDatePicker.minuteInterval = 15
        let startDate = Date().addingTimeInterval(1800)
        print(startDate)
        var startCalendar = Calendar.current.dateComponents([.year, .weekday, .day, .month, .hour, .minute], from: startDate)
        guard let startMinute = startCalendar.minute else { return }
        switch startMinute {
        case 0...14: startCalendar.minute = 15
        case 15...29: startCalendar.minute = 30
        case 30...44: startCalendar.minute = 45
        case 45...59: startCalendar.minute = 00;
        startCalendar.hour! += 1
        default: break
        }
        let startDateForatted = Calendar.current.date(from: startCalendar as DateComponents)! as Date?
        startDatePicker.minimumDate = startDateForatted
        startDatePicker.maximumDate = Date().addingTimeInterval(1208700)
        startTimeField?.inputView = startDatePicker
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.setDate(startDateForatted!, animated: true)
        startDatePicker.reloadInputViews()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneStartAction))
        doneButton.tintColor = colorCyan
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        startTimeField?.inputAccessoryView = toolbar
    }
    
    func setEndDatePicker() {
        endDatePicker.minuteInterval = 15
        let endDate = Date().addingTimeInterval(2700)
        var endCalendar = Calendar.current.dateComponents([.year, .weekday, .day, .month, .hour, .minute], from: endDate)
        guard let endMinute = endCalendar.minute else { return }
        switch endMinute {
        case 0...14: endCalendar.minute = 15
        case 15...29: endCalendar.minute = 30
        case 30...44: endCalendar.minute = 45
        case 45...59: endCalendar.minute = 00;
        endCalendar.hour! += 1
        default: break
        }
        let endDateForatted = Calendar.current.date(from: endCalendar as DateComponents)! as Date?
        endDatePicker.minimumDate = endDateForatted
        endDatePicker.maximumDate = Date().addingTimeInterval(1208700)
        endTimeField?.inputView = endDatePicker
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.setDate(endDateForatted!, animated: true)
        endDatePicker.reloadInputViews()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEndAction))
        doneButton.tintColor = colorCyan
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        endTimeField?.inputAccessoryView = toolbar
    }
    
    @objc func doneStartAction() {
        getDateFromPicker(into: startTimeField, from: startDatePicker)
           view.endEditing(true)
    }
    
    @objc func doneEndAction() {
        getDateFromPicker(into: endTimeField, from: endDatePicker)
           view.endEditing(true)
    }
    
    func getDateFromPicker(into sender: UITextField, from datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM HH:mm a"
        sender.text = formatter.string(from: datePicker.date)
    }
}
