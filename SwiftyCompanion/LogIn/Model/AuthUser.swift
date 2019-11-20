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
    private let intraURL = "https://api.intra.42.fr/"
    private var webAuthSession: ASWebAuthenticationSession?
    private var tokenJson: NSDictionary?
    private var userData: User?
    private var coalitionData: [Coalition?] = []
    private var examsPassed: Int = 0
    private var internshipsPassed: Int = 0
    
    private init() {}
}

extension AuthUser {
    func authorizeUser(completion: @escaping () -> ()) {
            webAuthSession = ASWebAuthenticationSession(url: URL(string: intraURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!,
                callbackURLScheme: callbackURI, completionHandler: { (url, error) in
            guard error == nil else { return }
            guard let url = url else { return }
            self.getUserToken(bearer: url.query!, completion: { () in
                completion()
            })
        })
        webAuthSession?.start()
    }
    
    private func getUserToken(bearer: String, completion: @escaping () -> ()) {
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
                    completion()
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
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    self.userData = try JSONDecoder().decode(User.self, from: data)
                    self.getCoalitionInfo(completion: { (coalition) in
                        self.getExamInfo(completion: { (exams, intern) in
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
        let url = NSURL(string: "\(self.intraURL)/v2/projects_users?filter[project_id]=118,212,11&user_id=\(userData?.cursus_users[0]?.user?.id ?? 0)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                guard let data = data else { return }
//                let json = try JSONSerialization.jsonObject(with: data)
//                print(json)
                if let dic: [NSDictionary] = try JSONSerialization.jsonObject(with: data) as? [NSDictionary] {
                    let a = dic[0]["teams"] as! [NSDictionary]
                    for i in 0..<a.count
                    {
                        if a[i]["validated?"] as! Int? == 1 {
                            self.examsPassed += 1
                        }
                    }
                    if dic.count > 0 {
                        if dic.count > 1 && dic[1]["validated?"] as? Bool? == true {
                            self.internshipsPassed += 1
                        }
                        if dic.count > 2 {
                            if dic[2]["validated?"] as? Bool? == true {
                                self.internshipsPassed += 1
                            }
                        }
                    }
                }
                completion(self.examsPassed, self.internshipsPassed)
            }
            catch let error {
                return print(error)
            }
            }.resume()
    }
}
