//
//  UserProfile.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/6/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

struct User: Decodable {
    var first_name: String?
    var last_name: String?
    var login: String?
    var image_url: String?
    var location: String?
    var wallet: Int?
    var correction_point: Int?
    var email: String?
    var cursus_users: [CursusUsers?]
    var campus: [Campus?]
//    var cursus: String
//    var campus: String
//    var phone: String
//    var avaliable: String
//    var coalition: String
//    var grade: String
//    var etec: String
//    var exams: Int
//    var internships: Int
    
    func description() {
        guard let cursus = cursus_users[0] else { return print("cursus_users == nil")}
        print("""
            first_name = \(first_name ?? "nil")
            last_name = \(last_name ?? "nil")
            Cursus_users:
                level = \(cursus.level ?? 0.0)
    """)
    }
}

struct CursusUsers: Decodable {
    var level: Float?
    var grade: String?
    var skills: [Skills?]
    var user: UserId?
}

struct Skills: Decodable {
    var id: Int?
    var level: Float?
    var name: String?
}

struct Campus: Decodable {
    var city: String?
    var country: String?
    var adress: String?
}

struct UserId: Decodable {
    var id: Int?
}

class UserInfo {
    var profileInfo: User?
//    var eventInfo: Event?
}
