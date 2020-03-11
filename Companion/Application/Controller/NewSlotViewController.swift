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
    var allComposedSlots: [ComposedSlot?] = []
    let colorCyan = #colorLiteral(red: 0, green: 0.7427903414, blue: 0.7441888452, alpha: 1)
    var startYear: Int?
    var endYear: Int?
    
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
        startYear = startCalendar.year
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
        startDatePicker.timeZone = .current
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
        endYear = endCalendar.year
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
        endDatePicker.timeZone = .current
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
    
    func checkOverlayAbsence() -> (Bool, String) {
        var range: DateInterval?
        let excludingTime = TimeInterval(1)
        let getDate = OtherMethods.shared.getDate
        guard let beginDate = getDate(startTimeField.text, "EEEE' 'd' 'MMM' 'h:mm' 'a") else {
            return (false, "Unable To Get Start Time") }
        guard let endDate = getDate(endTimeField.text, "EEEE' 'd' 'MMM' 'h:mm' 'a") else {
            return (false, "Unable To Get End Time") }
        var startCalendar = Calendar.current.dateComponents([.timeZone, .year, .weekday, .day, .month, .hour, .minute], from: beginDate)
        var endCalendar = Calendar.current.dateComponents([.timeZone, .year, .weekday, .day, .month, .hour, .minute], from: endDate)
        startCalendar.timeZone = .current
        endCalendar.timeZone = .current
        startCalendar.year = startYear
        endCalendar.year = endYear
        let endDateFormatted = Calendar.current.date(from: endCalendar as DateComponents)! as Date
        let startDateForatted = Calendar.current.date(from: startCalendar as DateComponents)! as Date
        print(startDateForatted, endDateFormatted)
        if startDateForatted < endDateFormatted {
            range = DateInterval(start: startDateForatted, end: endDateFormatted)
        } else {
            return (false, "Start Time Is More Than End Time")
        }
        for slot in allComposedSlots {
            guard let compBegin = slot?.beginAt else { break }
            guard let compEnd = slot?.endAt else { break }
            let rangeOfSlot = DateInterval(start: compBegin + excludingTime, end: compEnd - excludingTime)
            if range?.intersects(rangeOfSlot) == true {
                return (false, "This time range intersects with another slot. Change to another time please")
            }
        }
        return (true, "")
    }
    
    func getDateFromPicker(into sender: UITextField, from datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM HH:mm a"
        formatter.timeZone = .current
        sender.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func tapDone(_ sender: UIBarButtonItem) {
        let alert = OtherMethods.shared.alert
        if (startTimeField.text == "" || endTimeField.text == "") {
            alert("Error", "One or both time fields is empthy. Pick both dates before creating a slot")
            return
        }
        let overlay = checkOverlayAbsence()
        if overlay.0 == false {
            alert("Error", overlay.1)
            return
        }
        
    }
}
