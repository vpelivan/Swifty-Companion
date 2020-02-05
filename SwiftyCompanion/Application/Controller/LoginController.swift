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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var myInfo: UserData!
    var coalitionData: [Coalition?] = []
    var examsInternships: [ProjectsUsers?] = []
    let intraURL = AuthUser.shared.intraURL
    let callbackURI = AuthUser.shared.callbackURI
    let UID = AuthUser.shared.UID

    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 5.0
        activityIndicator.isHidden = true
    }
    
    @IBAction func tapLogIn(_ sender: UIButton) {
        guard let url = URL(string: "\(intraURL)/v2/me") else { return }
        authorizeUser(context: self, completion: {
            NetworkService.shared.getData(into: UserData.self, from: url) { User in
                self.myInfo = User as? UserData
                guard let userId = self.myInfo.id else { return }
                guard let url = URL(string: "\(self.intraURL)/v2/users/\(userId)/coalitions") else { return }
                NetworkService.shared.getData(into: [Coalition?].self, from: url) { Coalition in
                    self.coalitionData = Coalition as! [Coalition?]
                    guard let url = URL(string: "\(self.intraURL)/v2/projects_users?filter[project_id]=11,118,212&user_id=\(userId)") else { return }
                    NetworkService.shared.getData(into: [ProjectsUsers].self, from: url) { examsInternships in
                        self.examsInternships = examsInternships as! [ProjectsUsers?]
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.performSegue(withIdentifier: "goToProfile", sender: nil)
                        }
                    }
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBar = segue.destination as? UITabBarController {
            if let navi = tabBar.viewControllers?[0] as? UINavigationController {
                if let vc = navi.viewControllers.first as? ProfileViewController {
                    vc.myInfo = self.myInfo
                    vc.coalitionData = self.coalitionData
                    vc.examsInternships = self.examsInternships
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
    func authorizeUser(context: ASWebAuthenticationPresentationContextProviding, completion: @escaping () -> ()) {
        var webAuthSession: ASWebAuthenticationSession?
        let scope = AuthUser.shared.scope
        guard let url = URL(string: intraURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=\(scope)") else { return }
        webAuthSession = ASWebAuthenticationSession(url: url,
            callbackURLScheme: callbackURI, completionHandler: { (url, error) in
            guard error == nil else { return }
            guard let url = url else { return }
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.getUserToken(bearer: url.query!, completion: {
                    completion()
                })
        })
        webAuthSession?.presentationContextProvider = context
        webAuthSession?.start()
    }
    
    private func getUserToken(bearer: String, completion: @escaping () -> ()) {
        let secretKey = AuthUser.shared.secretKey
        let httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secretKey)&\(bearer)&redirect_uri=\(callbackURI)"
        
        guard let url = NSURL(string: intraURL+"oauth/token") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard error == nil else { return print(error!) }
            do {
                guard let data = data else { return }
                let token = try JSONDecoder().decode(Token.self, from: data)
                    AuthUser.shared.token = token
                    print(token)
                    completion()
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
    
//    public func getUserInfo(completion: @escaping (User, Coalition, Int, Int) -> ()) {
//            let token = tokenJson!["access_token"] as! String
//
//            guard let url = NSURL(string: "\(self.intraURL)/v2/me") else { return }
//            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "GET"
//            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//            let session = URLSession.shared
//            session.dataTask(with: request as URLRequest) {
//                (data, response, error) in
//                do
//                {
//                    guard let data = data else { return }
//                    self.userData = try JSONDecoder().decode(User.self, from: data)
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//                    print(json!)
//                    guard let projects = json!["projects_users"] as? [NSDictionary] else { return }
//                    for i in 0..<projects.count
//                    {
//                        if projects[i]["validated?"] as? Int? == 1 {
//                            self.userData?.projects_users[i]?.validated = 1
//                        }
//                    }
//                    self.getCoalitionInfo(completion: { (coalition) in
//                        self.getExamInfo(completion: { (exams, intern) in
//                            print(self.userData)
//                            completion(self.userData!, coalition, exams, intern)
//                            })
//                        })
//                }
//                catch let error {
//                    return print(error)
//                }
//            }.resume()
//        }
    
//Coaltions

//    func getCoalitionInfo(completion: @escaping (Coalition) -> ()) {
//        let token = tokenJson!["access_token"] as! String
//        let url = NSURL(string: "\(self.intraURL)/v2/users/\(userData?.cursus_users[0]?.user?.id ?? 0)/coalitions")
//        let request = NSMutableURLRequest(url: url! as URL)
//        let session = URLSession.shared
//
//        request.httpMethod = "GET"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        session.dataTask(with: request as URLRequest) {
//            (data, response, error) in
//            do
//            {
//                guard let data = data else { return }
////                let json = try JSONSerialization.jsonObject(with: data)
////                print(json)
//                self.coalitionData = try JSONDecoder().decode([Coalition?].self, from: data)
////                self.getSkillInfo()
//                completion(self.coalitionData[0]!)
//            }
//            catch let error {
//                return print(error)
//            }
//            }.resume()
//    }

//Exams, Internships
//    func getExamInfo(completion: @escaping (Int, Int) -> ()) {
//        let token = tokenJson!["access_token"] as! String
//        let url = NSURL(string: "\(self.intraURL)/v2/projects_users?filter[project_id]=11,118,212&user_id=\(userData?.cursus_users[0]?.user?.id ?? 0)")
//        let request = NSMutableURLRequest(url: url! as URL)
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        let session = URLSession.shared
//        session.dataTask(with: request as URLRequest) {
//            (data, response, error) in
//            guard let data = data else { return }
//            do
//            {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
//                guard let teams = json![0]["teams"] as? [NSDictionary] else { return }
//                for i in 0..<teams.count
//                {
//                    if teams[i]["validated?"] as? Int? == 1 {
//                        self.examsPassed += 1
//                    }
//                }
//                if json!.count > 0 {
//                    if json!.count > 1 && json![1]["validated?"] as? Bool? == true {
//                        self.internshipsPassed += 1
//                    }
//                    if json!.count > 2 {
//                        if json![2]["validated?"] as? Bool? == true {
//                            self.internshipsPassed += 1
//                        }
//                    }
//                }
//                completion(self.examsPassed, self.internshipsPassed)
//            }
//            catch {
//                return print("This error:\(error)")
//            }
//        }.resume()
//    }
}

