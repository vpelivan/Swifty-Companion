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
    var teams: [Teams?]
    var project: Project?
}

struct Project: Decodable {
    var id: Int?
    var name: String?
    var slug: String?
    var parent_id: Int?
}


struct Teams: Decodable {
    var created_at: String?
    var closed_at: String?
}

//{
//    "cursus_ids" =         (
//        1
//    );
//    "final_mark" = 100;
//    id = 1582886;
//    marked = 1;
//    "marked_at" = "2019-10-09T11:40:08.563Z";
//    occurrence = 0;
//    project =         {
//        id = 750;
//        name = "Day 05";
//        "parent_id" = 742;
//        slug = "piscine-swift-ios-day-05";
//    };
//    "retriable_at" = "2019-10-09T11:40:08.779Z";
//    status = finished;
//    teams =         (
//        {
//            "closed?" = 1;
//            "closed_at" = "2019-10-08T20:42:31.027Z";
//            "created_at" = "2019-10-04T11:50:12.543Z";
//            "final_mark" = 100;
//            id = 2837609;
//            "locked?" = 1;
//            "locked_at" = "2019-10-04T11:50:12.613Z";
//            name = "vpelivan's group";
//            "project_gitlab_path" = "<null>";
//            "project_id" = 750;
//            "project_session_id" = 2072;
//            "repo_url" = "vogsphere@vogsphere-2.unit.ua:intra/2019/activities/piscine_swift_ios_day_05/vpelivan";
//            "repo_uuid" = "intra-uuid-e01a8f8a-c507-4251-86bf-3850f29e3795-2837609";
//            status = finished;
//            "terminating_at" = "2019-10-23T20:42:31.027Z";
//            "updated_at" = "2019-10-09T11:40:08.852Z";
//            url = "https://api.intra.42.fr/v2/teams/2837609";
//            users =                 (
//                {
//                    id = 33768;
//                    leader = 1;
//                    login = vpelivan;
//                    occurrence = 0;
//                    "projects_user_id" = 1582886;
//                    url = "https://api.intra.42.fr/v2/users/vpelivan";
//                    validated = 1;
//                }
//            );
//            "validated?" = 1;
//        }
//    );
//    user =         {
//        id = 33768;
//        login = vpelivan;
//        url = "https://api.intra.42.fr/v2/users/vpelivan";
//    };
//    "validated?" = 1;
//},
