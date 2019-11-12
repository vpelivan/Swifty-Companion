//
//  LoginController.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/4/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    var myInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapLogIn(_ sender: UIButton) {
        AuthUser.shared.authorizeUser {
            AuthUser.shared.getUserInfo(completion: {userInfo in
                self.myInfo.profileInfo = userInfo
                self.performSegue(withIdentifier: "goToProfile", sender: nil)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navi = segue.destination as? UINavigationController {
            if let vc = navi.viewControllers.first as? ProfileViewController {
                vc.myInfo = self.myInfo
            }
        }
    }
}
