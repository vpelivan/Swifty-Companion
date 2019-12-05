//
//  File.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 12/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

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
