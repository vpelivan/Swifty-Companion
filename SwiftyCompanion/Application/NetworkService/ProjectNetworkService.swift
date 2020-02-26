//
//  File.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/27/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

class ProjectNetworkService {
    static let shared = ProjectNetworkService()
    private init() {}
    
    public func getProjectInfo(from url: URL, completion: @escaping ([ProjectsSessions]?, URLSession) -> ()) {
        var projectSessions: [ProjectsSessions]?
        guard let token = AuthUser.shared.token?.accessToken else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do {
                guard let data = data else { return }
                projectSessions = try JSONDecoder().decode([ProjectsSessions]?.self, from: data)
                completion(projectSessions, session)
            } catch let error {
                return print(error)
            }
        }.resume()
    }
    
    public func getTeamsInfo(url: URL, completion: @escaping (projectTeams?, URLSession) -> ()) {
        guard let token = AuthUser.shared.token?.accessToken else { return }

            let request = NSMutableURLRequest(url: url as URL)
            let session = URLSession.shared
            request.httpMethod = "GET"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do {
                    guard let data = data else { return }
                    let teams = try JSONDecoder().decode(projectTeams?.self, from: data)
                    completion(teams, session)
                } catch let error {
                    print(error)
                }
                }.resume()
        }
}

