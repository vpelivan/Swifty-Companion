//
//  OtherMethods.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/28/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import UIKit
import Foundation

class OtherMethods {
    static let shared = OtherMethods()
    private init() {}
        
    public func getDateAndTime(from date: String?) -> String {
        let dateFormatter = DateFormatter()
        if var date = date {
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            date = String(date.prefix(16)).replacingOccurrences(of: "T", with: " ")
            let formattedDate = dateFormatter.date(from: date)!
            date = dateFormatter.string(from: formattedDate.addingTimeInterval(7200))
            return date
        }
        return "-"
    }
    
    
    
    public func convertToLocalDate(from date: String?) -> Date? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let utcDate = dateFormatter.date(from: date)
        let localDate = utcDate?.toLocalTime()
        print(localDate)
        return localDate
    }
    
    public func convertToGlobalDate(from date: String?) -> Date? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let utcDate = dateFormatter.date(from: date)
        let localDate = utcDate?.toGlobalTime()
        return localDate
    }
    
    public func getDay(from date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'of' MMMM"
        let string = formatter.string(from: date)
        return string
    }
    
    public func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default, handler: nil))
            alert.view.layoutIfNeeded()
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }
}

extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
