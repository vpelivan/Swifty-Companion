//
//  File.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 12/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

//// MARK: - Token
//struct ClusterUsers: Decodable {
//    let endAt: String?
//    let id: Int?
//    let beginAt: String?
//    let primary: Bool?
//    let host: String?
//    let campusID: Int?
//    let user: ClusterUser?
//
//    enum CodingKeys: String, CodingKey {
//        case endAt = "end_at"
//        case id
//        case beginAt = "begin_at"
//        case primary, host
//        case campusID = "campus_id"
//        case user
//    }
//}
//
//// MARK: - User
//struct ClusterUser: Decodable {
//    let id: Int?
//    let login: String?
//    let url: String?
//}


struct ClusterUsers: Decodable {
    var begin_at: String? //"2019-12-05T14:45:57.180Z";
    var campus_id: Int?
    var end_at: String? // = "<null>";
    var host: String? // = e1r11p5;
    var id: Int? // = 10245773;
    var user: ClusterUser?
}

struct ClusterUser: Decodable {
    var id: Int? // = 33789;
    var login: String? // = vkorniie;
    var url: String? // = "https://api.intra.42.fr/v2/users/vkorniie";
}
