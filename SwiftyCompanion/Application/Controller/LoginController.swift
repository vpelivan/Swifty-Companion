//
//  LoginController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/4/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    @IBOutlet weak var logInButton: UIButton!
    var myInfo: UserInfo!
    let intraURL = AuthUser.shared.intraURL
    let callbackURI = AuthUser.shared.callbackURI
    let UID = AuthUser.shared.UID
    var tokenJson: NSDictionary?
    var userData: User?
    var coalitionData: [Coalition?] = []
    var examsPassed: Int = 0
    var internshipsPassed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func tapLogIn(_ sender: UIButton) {
        authorizeUser(context: self, completion: { tokenJson in
            self.getUserInfo(completion: {userInfo, coalitionInfo, examsPassed, internPassed in
                self.myInfo.profileInfo = userInfo
                self.myInfo.coalitionInfo = coalitionInfo
                self.myInfo.examsPassed = examsPassed
                self.myInfo.internPassed = internPassed
                self.myInfo.tokenJson = tokenJson
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToProfile", sender: nil)
                }
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBar = segue.destination as? UITabBarController {
            if let navi = tabBar.viewControllers?[0] as? UINavigationController {
                if let vc = navi.viewControllers.first as? ProfileViewController {
                    vc.myInfo = self.myInfo
                }
            }
        }
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

extension LoginController {
    func authorizeUser(context: ASWebAuthenticationPresentationContextProviding, completion: @escaping (NSDictionary) -> ()) {
        var webAuthSession: ASWebAuthenticationSession?
        let scope = AuthUser.shared.scope
        
        webAuthSession = ASWebAuthenticationSession(url: URL(string: intraURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=\(scope)")!,
            callbackURLScheme: callbackURI, completionHandler: { (url, error) in
            guard error == nil else { return }
            guard let url = url else { return }
            self.getUserToken(bearer: url.query!, completion: { (token) in
                AuthUser.shared.tokenJson = self.tokenJson
            completion(self.tokenJson!)
            })
        })
        webAuthSession?.presentationContextProvider = context
        webAuthSession?.start()
    }
    
    private func getUserToken(bearer: String, completion: @escaping (NSDictionary) -> ()) {
        let secretKey = AuthUser.shared.secretKey
        
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
                    AuthUser.shared.token = self.tokenJson!["access_token"] as? String
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
                    print(json!)
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
    
//Coaltions

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

//Exams, Internships
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

