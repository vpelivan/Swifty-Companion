//
//  AuthUser.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/6/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation
import AuthenticationServices

class AuthUser {
    static let shared = AuthUser()

    private let callbackURI = "SwiftyCompanion://SwiftyCompanion"
    private let UID = "7717d9aef2c877094b2020ebcf0fef76c9725112efc3934dff52774031732002"
    private let secretKey = "41a3ab521d7b5f7d0d402c019f7d73f0b8d10b2e32b506b2d88a3771930bee07"
    private var webAuthSession: ASWebAuthenticationSession?
    private var userData: User?
    private var coalitionData: [Coalition?] = []
    private var examsPassed: Int = 0
    private var internshipsPassed: Int = 0
    let intraURL = "https://api.intra.42.fr/"
    var tokenJson: NSDictionary?
    
    private init() {}
}

extension AuthUser {
    func authorizeUser(context: ASWebAuthenticationPresentationContextProviding, completion: @escaping (NSDictionary) -> ()) {
            webAuthSession = ASWebAuthenticationSession(url: URL(string: intraURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!,
                callbackURLScheme: callbackURI, completionHandler: { (url, error) in
            guard error == nil else { return }
            guard let url = url else { return }
            self.getUserToken(bearer: url.query!, completion: { (token) in
                completion(self.tokenJson!)
            })
        })
        self.webAuthSession?.presentationContextProvider = context
        webAuthSession?.start() 
    }
    
    private func getUserToken(bearer: String, completion: @escaping (NSDictionary) -> ()) {
        guard let url = NSURL(string: intraURL+"oauth/token") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secretKey)&\(bearer)&redirect_uri=\(callbackURI)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard error == nil else { return print(error!) }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if json!["error"] == nil {
                    self.tokenJson = NSDictionary(dictionary: json!)
                    print(self.tokenJson ?? 0)
                    completion(self.tokenJson!)
                } else {
                    print("Json error")
                }
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
    
    public func getUserInfo(completion: @escaping (User, Coalition, Int, Int) -> ()) {
            let token = tokenJson!["access_token"] as! String
            
            guard let url = NSURL(string: "\(self.intraURL)/v2/me") else { return }
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do
                {
                    guard let data = data else { return }

                    self.userData = try JSONDecoder().decode(User.self, from: data)
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//                    print(json!)
                    guard let projects = json!["projects_users"] as? [NSDictionary] else { return }
                    for i in 0..<projects.count
                    {
                        if projects[i]["validated?"] as? Int? == 1 {
                            self.userData?.projects_users[i]?.validated = 1
                        }
                    }
                    self.getCoalitionInfo(completion: { (coalition) in
                        self.getExamInfo(completion: { (exams, intern) in
//                            print(self.userData)
                            completion(self.userData!, coalition, exams, intern)
                            })
                        })
                }
                catch let error {
                    return print(error)
                }
            }.resume()
        }
}


//Coaltions
extension AuthUser {
    func getCoalitionInfo(completion: @escaping (Coalition) -> ()) {
        let token = tokenJson!["access_token"] as! String
        let url = NSURL(string: "\(self.intraURL)/v2/users/\(userData?.cursus_users[0]?.user?.id ?? 0)/coalitions")
        let request = NSMutableURLRequest(url: url! as URL)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                guard let data = data else { return }
//                let json = try JSONSerialization.jsonObject(with: data)
//                print(json)
                self.coalitionData = try JSONDecoder().decode([Coalition?].self, from: data)
//                self.getSkillInfo()
                completion(self.coalitionData[0]!)
            }
            catch let error {
                return print(error)
            }
            }.resume()
    }
}

//Exams, Internships
extension AuthUser {
    func getExamInfo(completion: @escaping (Int, Int) -> ()) {
        let token = tokenJson!["access_token"] as! String
        let url = NSURL(string: "\(self.intraURL)/v2/projects_users?filter[project_id]=11,118,212&user_id=\(userData?.cursus_users[0]?.user?.id ?? 0)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard let data = data else { return }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
                guard let teams = json![0]["teams"] as? [NSDictionary] else { return }
                for i in 0..<teams.count
                {
                    if teams[i]["validated?"] as? Int? == 1 {
                        self.examsPassed += 1
                    }
                }
                if json!.count > 0 {
                    if json!.count > 1 && json![1]["validated?"] as? Bool? == true {
                        self.internshipsPassed += 1
                    }
                    if json!.count > 2 {
                        if json![2]["validated?"] as? Bool? == true {
                            self.internshipsPassed += 1
                        }
                    }
                }
                completion(self.examsPassed, self.internshipsPassed)
            }
            catch {
                return print("This error:\(error)")
            }
        }.resume()
    }
}

