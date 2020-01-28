//
//  OtherMethods.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/28/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

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
}
