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

//[
//    {
//        "id": 4055,
//        "name": "Основные принципы функционионального программирования и преимущества в современном мире",
//        "description": "На встрече поговорим об:\r\n- принципах функционального программирования;\r\n- преимущества функционального программирования в современном мире;\r\n- карьерных возможностях в этом направлении в компании Intetics.\r\n\r\nСпикер: Александр Капляр – Software engineer в компании Intetics и выпускник UNIT Factory.",
//        "location": "Multiverse",
//        "kind": "event",
//        "max_people": 50,
//        "nbr_subscribers": 23,
//        "begin_at": "2020-01-31T16:00:00.000Z",
//        "end_at": "2020-01-31T17:30:00.000Z",
//        "campus_ids": [
//            8
//        ],
//        "cursus_ids": [
//            1
//        ],
//        "created_at": "2020-01-23T15:28:28.256Z",
//        "updated_at": "2020-01-28T15:09:01.676Z",
//        "prohibition_of_cancellation": null,
//        "waitlist": {
//            "id": 1263,
//            "waitlistable_id": 4055,
//            "waitlistable_type": "Event",
//            "created_at": "2020-01-23T15:28:28.289Z",
//            "updated_at": "2020-01-23T15:28:28.289Z"
//        },
//        "themes": []
//    }
//]
