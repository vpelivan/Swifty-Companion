//
//  TokenModel.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/2/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation

// MARK: - Token
struct Token: Codable {
    let accessToken: String?
    let createdAt, expiresIn: Int?
    let refreshToken, scope, tokenType: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case createdAt = "created_at"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case tokenType = "token_type"
    }
}
