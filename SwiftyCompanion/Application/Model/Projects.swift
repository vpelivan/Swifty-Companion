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

struct ProjectsUsers: Decodable {
    var project_sessions: [ProjectSession?]
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

struct TeamsData: Decodable {
    var teams: [Teams?]
}

struct Teams: Decodable {
    var name: String?
    var created_at: String?
    var updated_at: String?
    var users: [TeamUsers?]
}

struct TeamUsers: Decodable {
    var id: Int?
    var leader: Bool?
    var login: String?
    var url: String?
    
}
//MARK: FDF TEAMS:

//{
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
//
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
//}


//MARK: - COREWAR TEAMS:

//{
//    "current_team_id" = "<null>";
//    "cursus_ids" =     (
//        1
//    );
//    "final_mark" = 125;
//    id = 1424256;
//    marked = 1;
//    "marked_at" = "2019-09-04T17:25:24.605Z";
//    occurrence = 1;
//    project =     {
//        id = 22;
//        name = Corewar;
//        "parent_id" = "<null>";
//        slug = corewar;
//    };
//    "retriable_at" = "2019-09-11T17:25:24.811Z";
//    status = finished;
//    teams =     (
//                {
//            "closed?" = 1;
//            "closed_at" = "2019-09-03T17:03:06.019Z";
//            "created_at" = "2019-07-15T08:17:19.987Z";
//            "final_mark" = 125;
//            id = 2654940;
//            "locked?" = 1;
//            "locked_at" = "2019-07-15T08:22:09.629Z";
//            name = "Corewar team";
//            "project_gitlab_path" = "<null>";
//            "project_id" = 22;
//            "project_session_id" = 1131;
//            "repo_url" = "vogsphere@vogsphere-2.unit.ua:intra/2019/activities/corewar/vpelivan";
//            "repo_uuid" = "intra-uuid-0c0389f4-6236-4012-a565-02e9448478ca-2654940";
//            status = finished;
//            "terminating_at" = "<null>";
//            "updated_at" = "2019-09-04T17:25:24.383Z";
//            url = "https://api.intra.42.fr/v2/teams/2654940";
//            users =             (
//                                {
//                    id = 33768;
//                    leader = 1;
//                    login = vpelivan;
//                    occurrence = 0;
//                    "projects_user_id" = 1424256;
//                    url = "https://api.intra.42.fr/v2/users/vpelivan";
//                    validated = 1;
//                },
//                                {
//                    id = 41784;
//                    leader = 0;
//                    login = vdanyliu;
//                    occurrence = 0;
//                    "projects_user_id" = 1439237;
//                    url = "https://api.intra.42.fr/v2/users/vdanyliu";
//                    validated = 1;
//                },
//                                {
//                    id = 41845;
//                    leader = 0;
//                    login = dkhaliul;
//                    occurrence = 0;
//                    "projects_user_id" = 1363876;
//                    url = "https://api.intra.42.fr/v2/users/dkhaliul";
//                    validated = 1;
//                },
//                                {
//                    id = 41907;
//                    leader = 0;
//                    login = vpozniak;
//                    occurrence = 0;
//                    "projects_user_id" = 1389309;
//                    url = "https://api.intra.42.fr/v2/users/vpozniak";
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
//}
