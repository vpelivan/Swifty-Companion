//
//  UserProfile.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/6/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation


struct UserPreview: Decodable {
    let id: Int?
    let lastName, login, firstName, displayname: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case displayname
        case firstName = "first_name"
        case id
        case imageURL = "image_url"
        case lastName = "last_name"
        case login
    }
}

// MARK: - UserData
struct UserData: Decodable {
    let achievements: [Achievement]?
    let campus: [Campus]?
    let campusUsers: [CampusUser]?
    let correctionPoint: Int?
    let cursusUsers: [CursusUser]?
    let displayname, email: String?
    let firstName: String?
    let id: Int?
    let imageURL: String?
    let languagesUsers: [LanguagesUser]?
    let lastName, location, login: String?
    let patroned: [Patroned]?
    let phone, poolMonth: String?
    let poolYear: String?
    let projectsUsers: [ProjectsUser]?
    let staff: Bool?
    let url: String?
    let wallet: Int?

    enum CodingKeys: String, CodingKey {
        case achievements, campus
        case campusUsers = "campus_users"
        case correctionPoint = "correction_point"
        case cursusUsers = "cursus_users"
        case displayname, email
        case firstName = "first_name"
        case id
        case imageURL = "image_url"
        case languagesUsers = "languages_users"
        case lastName = "last_name"
        case location, login, patroned, phone
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case projectsUsers = "projects_users"
        case staff = "staff?"
        case url, wallet
    }
}

// MARK: - Achievement(UserData)
struct Achievement: Decodable {
    let achievementDescription: String?
    let id: Int?
    let image, kind, name: String?
    let nbrOfSuccess: Int?
    let tier: String?
    let usersURL: String?
    let visible: Bool?

    enum CodingKeys: String, CodingKey {
        case achievementDescription = "description"
        case id, image, kind, name
        case nbrOfSuccess = "nbr_of_success"
        case tier
        case usersURL = "users_url"
        case visible
    }
}

// MARK: - Campus(UserData)
struct Campus: Decodable {
    let address, city, country: String?
    let facebook: String?
    let id: Int?
    let language: Language?
    let name, timeZone, twitter: String?
    let usersCount, vogsphereID: Int?
    let website: String?
    let zip: String?

    enum CodingKeys: String, CodingKey {
        case address, city, country, facebook, id, language, name
        case timeZone = "time_zone"
        case twitter
        case usersCount = "users_count"
        case vogsphereID = "vogsphere_id"
        case website, zip
    }
}

// MARK: - Language (Campus(UserData))
struct Language: Decodable {
    let createdAt: String?
    let id: Int?
    let identifier, name, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, identifier, name
        case updatedAt = "updated_at"
    }
}

// MARK: - CampusUser
struct CampusUser: Decodable {
    let campusID, id, userID: Int?
    let isPrimary: Bool?

    enum CodingKeys: String, CodingKey {
        case campusID = "campus_id"
        case id
        case isPrimary = "is_primary"
        case userID = "user_id"
    }
}

// MARK: - CursusUser
struct CursusUser: Decodable {
    let beginAt, blackholedAt: String?
    let cursus: Cursus?
    let cursusID: Int?
    let endAt, grade: String?
    let hasCoalition: Bool?
    let id: Int?
    
    let level: Float?
    let skills: [Skill]?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case beginAt = "begin_at"
        case blackholedAt = "blackholed_at"
        case cursus
        case cursusID = "cursus_id"
        case endAt = "end_at"
        case grade
        case hasCoalition = "has_coalition"
        case id, level, skills, user
    }
}

// MARK: - Cursus
struct Cursus: Decodable {
    let createdAt: String?
    let id: Int?
    let name, slug: String?
    let parentID: Int?
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, name, slug
        case parentID = "parent_id"
    }
}

// MARK: - Skill
struct Skill: Decodable {
    let id: Int?
    let level: Float?
    let name: String?
}

// MARK: - User
struct User: Decodable {
    let id: Int?
    let login: String?
    let url: String?
}

// MARK: - LanguagesUser
struct LanguagesUser: Decodable {
    let createdAt: String?
    let id, languageID, position, userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case languageID = "language_id"
        case position
        case userID = "user_id"
    }
}

// MARK: - Patroned
struct Patroned: Decodable {
    let createdAt: String?
    let godfatherID, id: Int?
    let ongoing: Bool?
    let updatedAt: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case godfatherID = "godfather_id"
        case id, ongoing
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

// MARK: - ProjectsUser
struct ProjectsUser: Decodable {
    let currentTeamID: Int?
    let cursusIDS: [Int]?
    let finalMark: Int?
    let id: Int?
    let marked: Bool?
    let markedAt: String?
    let occurrence: Int?
    let project: Cursus?
    let retriableAt, status: String?
    let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case currentTeamID = "current_team_id"
        case cursusIDS = "cursus_ids"
        case finalMark = "final_mark"
        case id
        case marked
        case markedAt = "marked_at"
        case occurrence, project
        case retriableAt = "retriable_at"
        case status
        case validated = "validated?"
    }
}

//class UserInfo {
//    var profileInfo: User?
//    var coalitionInfo: Coalition?
//    var examsPassed: Int = 0
//    var internPassed: Int = 0
//    var tokenJson: NSDictionary?
//    //    var eventInfo: Event?
//}
//
//struct User: Decodable {
//    var first_name: String?
//    var last_name: String?
//    var login: String?
//    var image_url: String?
//    var location: String?
//    var wallet: Int?
//    var correction_point: Int?
//    var email: String?
//    var cursus_users: [CursusUsers?]
//    var campus: [Campus?]
//    var projects_users: [Projects?]
//
//    func description() {
//        guard let cursus = cursus_users[0] else { return print("cursus_users == nil")}
//        print("""
//            first_name = \(first_name ?? "nil")
//            last_name = \(last_name ?? "nil")
//            Cursus_users:
//                level = \(cursus.level ?? 0.0)
//    """)
//    }
//}
//
//struct CursusUsers: Decodable {
//    var level: Float?
//    var grade: String?
//    var skills: [Skills?]
//    var user: UserId?
//}
//
//struct Skills: Decodable {
//    var id: Int?
//    var level: Float?
//    var name: String?
//}
//
//struct Campus: Decodable {
//    var city: String?
//    var country: String?
//    var address: String?
//}
//
//struct UserId: Decodable {
//    var id: Int?
//}
