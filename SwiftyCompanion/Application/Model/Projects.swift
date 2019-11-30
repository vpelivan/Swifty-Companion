//
//  Projects.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 11/15/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

struct Projects: Decodable {
    var final_mark: Int?
    var id: Int?
    var status: String?
    var cursus_ids: [Int?]
    var project: Project?
    var validated: Int?
}

struct Project: Decodable {
    var id: Int?
    var name: String?
    var parent_id: Int?
    var slug: String?
}

struct ProjectsUsers: Decodable{
    var project_sessions: [ProjectSession?]
}

struct ProjectSession: Decodable {
    var description: String?
    var difficulty: Int?
    var estimate_time: Int?
    var solo: Bool?
    var objectives: [String]?
}
//{
//    "begin_at" = "<null>";
//    "campus_id" = 15;
//    commit = "<null>";
//    "created_at" = "2019-10-15T11:16:56.083Z";
//    "cursus_id" = 8;
//    description = "This project invites you to create a virtual arena and to compete with programs coded in a simplistic language. You will thus approach the design of a VM (with the instructions that it recognizes, the registers, etc), and the problems of compilation of an assembly language in bytecode. With, as a bonus, the pleasure of making your champions compete on your arena!";
//    difficulty = 375;
//    "duration_days" = "<null>";
//    "end_at" = "<null>";
//    "estimate_time" = "<null>";
//    id = 3919;
//    "is_subscriptable" = 1;
//    "max_people" = "<null>";
//    objectives =     (
//        Compilation,
//        "Simplistic virtual machine",
//        "Simplistic assembly type language",
//        "Visual rendering"
//    );
//    "project_id" = 22;
//    scales =     (
//        {
//            "correction_number" = 5;
//            id = 55;
//            "is_primary" = 1;
//        }
//    );
//    solo = 0;
//    "team_behaviour" = user;
//    "terminating_after" = 14;
//    "updated_at" = "2019-10-23T16:32:49.594Z";
//    uploads =     (
//    );
//},
