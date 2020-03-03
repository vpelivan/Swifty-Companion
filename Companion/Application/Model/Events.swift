//
//  Events.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/29/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation

// MARK: - Event
struct Event: Decodable {
    let id: Int?
    let name, eventDescription, location, kind: String?
    let maxPeople, nbrSubscribers: Int?
    let beginAt, endAt: String?
    let campusIDS, cursusIDS: [Int]?
    let createdAt, updatedAt: String?
    let waitlist: Waitlist?

    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDescription = "description"
        case location, kind
        case maxPeople = "max_people"
        case nbrSubscribers = "nbr_subscribers"
        case beginAt = "begin_at"
        case endAt = "end_at"
        case campusIDS = "campus_ids"
        case cursusIDS = "cursus_ids"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case waitlist
    }
}

// MARK: - Waitlist
struct Waitlist: Decodable {
    let id, waitlistableID: Int?
    let waitlistableType, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case waitlistableID = "waitlistable_id"
        case waitlistableType = "waitlistable_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - EventsUsers
struct EventsUser: Decodable {
    let id, eventID, userID: Int?
    let user: UserOfEvent?
    let event: SingleEventUser?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case userID = "user_id"
        case user, event
    }
}

// MARK: - Event
struct SingleEventUser: Decodable {
    let id: Int?
    let name, eventDescription, location, kind: String?
    let maxPeople, nbrSubscribers: Int?
    let beginAt, endAt: String?
    let campusIDS, cursusIDS: [Int]?
    let createdAt, updatedAt: String?
    let waitlist: EventUserWaitlist?

    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDescription = "description"
        case location, kind
        case maxPeople = "max_people"
        case nbrSubscribers = "nbr_subscribers"
        case beginAt = "begin_at"
        case endAt = "end_at"
        case campusIDS = "campus_ids"
        case cursusIDS = "cursus_ids"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case waitlist
    }
}

// MARK: - Waitlist
struct EventUserWaitlist: Codable {
    let id, waitlistableID: Int?
    let waitlistableType, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case waitlistableID = "waitlistable_id"
        case waitlistableType = "waitlistable_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct UserOfEvent: Codable {
    let id: Int?
    let login: String?
    let url: String?
}

//MARK: - A Structure to pass between controllers
struct EventsData{
    var event: Event?
    var startDay: String?
    var startMonth: String?
    var duration: String?
    var status: String?
    var when: String?
    var unsubscribeID: Int?
}
