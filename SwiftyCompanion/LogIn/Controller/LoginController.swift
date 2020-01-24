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
    
    var myInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapLogIn(_ sender: UIButton) {
        AuthUser.shared.authorizeUser(context: self, completion: { tokenJson in
            AuthUser.shared.getUserInfo(completion: {userInfo, coalitionInfo, examsPassed, internPassed in
                self.myInfo.profileInfo = userInfo
                self.myInfo.coalitionInfo = coalitionInfo
                self.myInfo.examsPassed = examsPassed
                self.myInfo.internPassed = internPassed
                self.myInfo.tokenJson = tokenJson
//                self.myInfo.projectsInfo = projectsInfo
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
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
