//
//  TokenData.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/11/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

struct TokenData {
    private var access_token: String
    private var created_at: Int
    private var expires_in: Int
    private var refresh_token: String
    private var scope: String
    private var token_type: String
    
    init?(dict: [String : AnyObject]) {
        guard let access_token = dict["access_token"] as? String,
        let created_at = dict["created_at"] as? Int,
        let expires_in = dict["expires_in"] as? Int,
        let refresh_token = dict["refresh_token"] as? String,
        let scope = dict["scope"] as? String,
        let token_type = dict["token_type"] as? String else { return nil }
        
        self.access_token = access_token
        self.created_at = created_at
        self.expires_in = expires_in
        self.refresh_token = refresh_token
        self.scope = scope
        self.token_type = token_type
    }
}

