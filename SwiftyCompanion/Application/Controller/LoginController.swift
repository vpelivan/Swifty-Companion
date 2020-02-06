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
    

    private func stopIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func errorHandler(to handle: Result<String, Error>, completion: ()->()) {
        switch handle {
        case .success(let string):
            print(string)
            completion()
        case .failure(let error):
            print("Failed to load data: ", error)
            self.stopIndicator()
            return
        }
    }
    
    @IBAction func tapLogIn(_ sender: UIButton) {
        guard let url = URL(string: "\(intraURL)/v2/me") else { return }
        authorizeUser(context: self, completion: {
            NetworkService.shared.getData(into: UserData.self, from: url) { User, result in
                self.errorHandler(to: result) {
                    self.myInfo = User as? UserData
                    guard let userId = self.myInfo.id else { return }
                    guard let url = URL(string: "\(self.intraURL)/v2/users/\(userId)/coalitions") else { return }
                    NetworkService.shared.getData(into: [Coalition?].self, from: url) { Coalition, result in
                        self.errorHandler(to: result) {
                            self.coalitionData = Coalition as! [Coalition?]
                            guard let url = URL(string: "\(self.intraURL)/v2/projects_users?filter[project_id]=11,118,212&user_id=\(userId)") else { return }
                            NetworkService.shared.getData(into: [ProjectsUsers].self, from: url) { examsInternships, result in
                                self.errorHandler(to: result) {
                                    self.examsInternships = examsInternships as! [ProjectsUsers?]
                                    self.stopIndicator()
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "goToProfile", sender: nil)
                                    }
                                }
                            }
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
}
