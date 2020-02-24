//
//  Evaluations.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/23/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

struct Evaluation: Decodable {
    let id, scaleID: Int?
    let comment: String?
    let createdAt, updatedAt: String?
    let feedback: String?
    let finalMark: Int?
    let flag: Flag?
    let beginAt: String?
    let correcteds: [Correct]?
    let corrector: Corrector?
    let truant: Truant?
    let filledAt: String?
    let questionsWithAnswers: [QwA]?
    let scale: Scale?
    let team: ScaleTeam?
    let feedbacks: [Feedback]?
    var projectName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case scaleID = "scale_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case feedback
        case finalMark = "final_mark"
        case flag
        case beginAt = "begin_at"
        case correcteds, corrector, truant
        case filledAt = "filled_at"
        case questionsWithAnswers = "questions_with_answers"
        case scale, team, feedbacks
    }
}

struct Corrector: Decodable {
    let invisible: String?
    let visible: Correct?
    
    // Where we determine what type the value is
    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()
        // Check for a String
        do {
            invisible = try container.decode(String?.self)
            visible = nil
        } catch {
            // Check for Correct
            visible = try container.decode(Correct?.self)
            invisible = nil
        }
    }
}

// MARK: - Correct
struct Correct: Decodable {
    let id: Int?
    let login: String?
    let url: String?
}

// MARK: - Flag
struct Flag: Decodable {
    let id: Int?
    let name: String?
    let positive: Bool?
    let icon, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, positive, icon
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Scale
struct Scale: Decodable {
    let id, evaluationID: Int?
    let name: String?
    let isPrimary: Bool?
    let comment, introductionMd, disclaimerMd, guidelinesMd: String?
    let createdAt: String?
    let correctionNumber, duration: Int?
    let manualSubscription: Bool?
    let languages: [EvaluationLanguage]?
    let flags: [Flag]?
    let free: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case evaluationID = "evaluation_id"
        case name
        case isPrimary = "is_primary"
        case comment
        case introductionMd = "introduction_md"
        case disclaimerMd = "disclaimer_md"
        case guidelinesMd = "guidelines_md"
        case createdAt = "created_at"
        case correctionNumber = "correction_number"
        case duration
        case manualSubscription = "manual_subscription"
        case languages, flags, free
    }
}

// MARK: - Language
struct EvaluationLanguage: Decodable {
    let id: Int?
    let name, identifier, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, identifier
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Team
struct ScaleTeam: Decodable {
    let id: Int?
    let name: String?
    let url: String?
    let finalMark: Int?
    let projectID: Int?
    let createdAt, updatedAt, status: String?
    let terminatingAt: String?
    let users: [EvaluationUser]?
    let locked: Bool?
    let validated: Bool?
    let closed: Bool?
    let repoURL, repoUUID, lockedAt, closedAt: String?
    let projectSessionID: Int?
    let projectGitlabPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, url
        case finalMark = "final_mark"
        case projectID = "project_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case terminatingAt = "terminating_at"
        case users
        case locked = "locked?"
        case validated = "validated?"
        case closed = "closed?"
        case repoURL = "repo_url"
        case repoUUID = "repo_uuid"
        case lockedAt = "locked_at"
        case closedAt = "closed_at"
        case projectSessionID = "project_session_id"
        case projectGitlabPath = "project_gitlab_path"
    }
}

// MARK: - User
struct EvaluationUser: Decodable {
    let id: Int?
    let login: String?
    let url: String?
    let leader: Bool?
    let occurrence: Int?
    let validated: Bool?
    let projectsUserID: Int?

    enum CodingKeys: String, CodingKey {
        case id, login, url, leader, occurrence, validated
        case projectsUserID = "projects_user_id"
    }
}

// MARK: - Truant
struct Truant: Decodable {
}

// MARK: - Feedback
struct Feedback: Decodable {
    let id: Int?
    let user: FeedbackUser?
    let feedbackableType: String?
    let feedbackableID: Int?
    let comment: String?
    let rating: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, user
        case feedbackableType = "feedbackable_type"
        case feedbackableID = "feedbackable_id"
        case comment, rating
        case createdAt = "created_at"
    }
}

struct FeedbackUser: Decodable {
    let login: String?
    let id: Int?
    let url: String?
}

// MARK: - QwA
struct QwA: Decodable {
    let id: Int?
    let name, guidelines, rating, kind: String?
    let answers: [Answer]?
}

// MARK: - Answer
struct Answer: Decodable {
    let value: Int?
    let answer: String?
}

struct ProjectName: Decodable {
    let id: Int?
    let name: String?
}
