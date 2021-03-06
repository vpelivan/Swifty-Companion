//
//  Projects.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 11/15/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

// MARK: - ProjectsUsers
struct ProjectsUsers: Decodable {
    let id, occurrence, finalMark: Int?
    let status: String?
    let validated: Bool?
    let currentTeamID: Int?
    let project: Project?
    let cursusIDS: [Int]?
    let markedAt: String?
    let marked: Bool?
    let retriableAt: String?
    let teams: [Team]?

    enum CodingKeys: String, CodingKey {
        case id, occurrence
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case currentTeamID = "current_team_id"
        case project
        case cursusIDS = "cursus_ids"
        case markedAt = "marked_at"
        case marked
        case retriableAt = "retriable_at"
        case teams
    }
}

struct Project: Decodable {
    var id: Int?
    var name: String?
    var parentID: Int?
    var slug: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case parentID = "parent_id"
    }
}

struct ProjectsSessions: Decodable {
    var projectSessions: [ProjectSession?]
    
    enum CodingKeys: String, CodingKey {
        case projectSessions = "project_sessions"
    }
}

struct ProjectSession: Decodable {
    var description: String?
    var campus_id: Int?
    var difficulty: Int?
    var estimate_time: Int?
    var solo: Bool?
//    var objectives: [String?]
    var scales: [Scales?]
}

struct Scales: Decodable {
    var correction_number: Int?
}

// MARK: - Project Teams
struct projectTeams: Decodable {
    let markedAt: String?
    let retriableAt: String?
    let teams: [Team]?
    let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case markedAt = "marked_at"
        case retriableAt = "retriable_at"
        case teams
        case validated = "validated?"
    }
}

// MARK: - Single Team (Project Teams)
struct Team: Decodable {
    let closed: Bool?
    let closedAt, createdAt: String?
    let finalMark, id: Int?
    let locked: Bool?
    let lockedAt, name, projectGitlabPath: String?
    let projectID, projectSessionID: Int?
    let repoURL, repoUUID, status, terminatingAt: String?
    let updatedAt: String?
    let url: String?
    let users: [UserElement]?
    let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case closed = "closed?"
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case finalMark = "final_mark"
        case id
        case locked = "locked?"
        case lockedAt = "locked_at"
        case name
        case projectGitlabPath = "project_gitlab_path"
        case projectID = "project_id"
        case projectSessionID = "project_session_id"
        case repoURL = "repo_url"
        case repoUUID = "repo_uuid"
        case status
        case terminatingAt = "terminating_at"
        case updatedAt = "updated_at"
        case url, users
        case validated = "validated?"
    }
}

// MARK: - UserElement (Project Teams)
struct UserElement: Decodable {
    let id: Int?
    let leader: Bool?
    let login: String?
    let occurrence, projectsUserID: Int?
    let url: String?
    let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case id, leader, login, occurrence
        case projectsUserID = "projects_user_id"
        case url, validated
    }
}


//Optional({
//    "current_team_id" = 2495613;
//    "cursus_ids" =     (
//        1
//    );
//    "final_mark" = 116;
//    id = 1296002;
//    marked = 1;
//    "marked_at" = "2019-03-31T18:27:32.624Z";
//    occurrence = 1;
//    project =     {
//        id = 4;
//        name = FdF;
//        "parent_id" = "<null>";
//        slug = fdf;
//    };
//    "retriable_at" = "2019-04-04T18:27:32.993Z";
//    status = finished;
//    teams =     (
//                {
//            "closed?" = 1;
//            "closed_at" = "2019-03-27T15:09:24.168Z";
//            "created_at" = "2019-03-13T14:37:56.897Z";
//            "final_mark" = 0;
//            id = 2479071;
//            "locked?" = 1;
//            "locked_at" = "2019-03-13T14:37:57.005Z";
//            name = "vpelivan's group";
//            "project_gitlab_path" = "<null>";
//            "project_id" = 4;
//            "project_session_id" = 1060;
//            "repo_url" = "vogsphere@vogsphere-2.unit.ua:intra/2019/activities/fdf/vpelivan";
//            "repo_uuid" = "intra-uuid-75e9f691-734e-4a41-b5ef-adcefcf29360-2479071";
//            status = finished;
//            "terminating_at" = "<null>";
//            "updated_at" = "2019-03-27T16:03:08.574Z";
//            url = "https://api.intra.42.fr/v2/teams/2479071";
//            users =             (
//                                {
//                    id = 33768;
//                    leader = 1;
//                    login = vpelivan;
//                    occurrence = 0;
//                    "projects_user_id" = 1296002;
//                    url = "https://api.intra.42.fr/v2/users/vpelivan";
//                    validated = 1;
//                }
//            );
//            "validated?" = 0;
//        },
//                {
//            "closed?" = 1;
//            "closed_at" = "2019-03-31T15:15:27.094Z";
//            "created_at" = "2019-03-31T15:03:43.592Z";
//            "final_mark" = 116;
//            id = 2495613;
//            "locked?" = 1;
//            "locked_at" = "2019-03-31T15:03:43.741Z";
//            name = "vpelivan's group-1";
//            "project_gitlab_path" = "<null>";
//            "project_id" = 4;
//            "project_session_id" = 1060;
//            "repo_url" = "vogsphere@vogsphere-2.unit.ua:intra/2019/activities/fdf/vpelivan2";
//            "repo_uuid" = "intra-uuid-8cc66dd5-4462-47e3-9e31-275b77ac33bd-2495613";
//            status = finished;
//            "terminating_at" = "<null>";
//            "updated_at" = "2019-03-31T18:27:32.161Z";
//            url = "https://api.intra.42.fr/v2/teams/2495613";
//            users =             (
//                                {
//                    id = 33768;
//                    leader = 1;
//                    login = vpelivan;
//                    occurrence = 1;
//                    "projects_user_id" = 1296002;
//                    url = "https://api.intra.42.fr/v2/users/vpelivan";
//                    validated = 1;
//                }
//            );
//            "validated?" = 1;
//        }
//    );
//    user =     {
//        id = 33768;
//        login = vpelivan;
//        url = "https://api.intra.42.fr/v2/users/vpelivan";
//    };
//    "validated?" = 1;
//})
