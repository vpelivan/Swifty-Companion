//
//  EventsNetworkService.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/29/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

class EventsNeworkSevice {
    static let shared = EventsNeworkSevice()
    private init() {}
    
    public func subscribeToEvent(eventID: Int, userID: Int, completion: @escaping ()->()) {
        guard let token = AuthUser.shared.token?.accessToken else { return }
        let intraURL = AuthUser.shared.intraURL
        let url = URL(string: "\(intraURL)v2/events_users")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpBody = "events_user[event_id]=\(eventID)&events_user[user_id]=\(userID)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request  as URLRequest)
        {
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                    if (dictionary["error"] == nil) {
                        print("Subscribtion Succeded")
                        completion()
                    }
                    else {
                        print(dictionary)
                    }
                }
                else {
                    print("Subscribtion Failed")
                }
            }
            catch (let error) {
                print(error)
            }
        }.resume()
    }
    
    public func unsubscribeFromEvent(with subscriptionID: Int, completion: @escaping ()->()) {
        let intraURL = AuthUser.shared.intraURL
        guard let token = AuthUser.shared.token?.accessToken else { return }
        let url = URL(string: "\(intraURL)v2/events_users/\(subscriptionID)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request  as URLRequest)
        {
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                    if (dictionary["error"] == nil) {
                        print("Unsubscribtion Succeded")
                        completion()
                    }
                    else {
                        print(dictionary)
                    }
                }
                else {
                    print("Unsubscribtion Failed")
                }
            }
            catch (let error) {
                print(error)
            }
        }.resume()
    }
}
