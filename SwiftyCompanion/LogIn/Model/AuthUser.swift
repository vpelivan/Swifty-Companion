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
    private var UserData: User?
    
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
                    print(self.tokenJson!)
                    completion()
                } else {
                    print("Json error")
                }
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
    
    public func getUserInfo(completion: @escaping (User) -> ()) {
            let token = tokenJson!["access_token"] as! String
            
            guard let url = NSURL(string: "\(self.intraURL)/v2/me") else { return }
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
//            self.UserData =
            session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do
                {
                    guard let data = data else { return }
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    self.UserData = try JSONDecoder().decode(User.self, from: data)
//                    print(self.UserData!)
//                    self.UserData?.description()
                    DispatchQueue.main.async {
                        self.getCoalitionInfo()
                        completion(self.UserData!)
                    }

                }
                catch let error {
                    return print(error)
                }
            }.resume()
        }
}

extension AuthUser {
    func getCoalitionInfo() {
        let token = tokenJson!["access_token"] as! String
        
        print("COALITION")
        let url = NSURL(string: "\(self.intraURL)/v2/users/\(UserData?.cursus_users[0]?.user?.id ?? 0)/coalitions")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        //            self.UserData =
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                guard let data = data else { return }
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
//                self.UserData = try JSONDecoder().decode(User.self, from: data)
                //                    print(self.UserData!)
                //                    self.UserData?.description()
                
            }
            catch let error {
                return print(error)
            }
            }.resume()
    }
}
