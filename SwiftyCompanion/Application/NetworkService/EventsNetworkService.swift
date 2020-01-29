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
    
    public func getEvents(from url: URL, completion: @escaping ([Event?]) -> ()) {
        guard let token = AuthUser.shared.token else { return }
        let request = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do {
                guard let data = data else { return }
                let eventStruct = try JSONDecoder().decode([Event?].self, from: data)
                completion(eventStruct)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
