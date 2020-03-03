//
//  AuthUser.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/6/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

class AuthUser {
    static let shared = AuthUser()
    let callbackURI = "Companion://Companion"
    let UID = "7717d9aef2c877094b2020ebcf0fef76c9725112efc3934dff52774031732002"
    let secretKey = "41a3ab521d7b5f7d0d402c019f7d73f0b8d10b2e32b506b2d88a3771930bee07"
    let intraURL = "https://api.intra.42.fr/"
    let scope = "public+forum+projects+profile+elearning+tig"
    var bearer: String?
    var token: Token?
    var userID: Int?
    var campusID: Int?
    var login: String?
    init() {}
}
