//
//  Coalition.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/13/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

struct Coalition: Decodable {
    let color: String?
    let coverUrl: String?
    let name: String?
    let id: Int?
    let score: Int?
    let imageUrl: String?
    let slug: String?
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case color, name, slug
        case coverUrl = "cover_url"
        case imageUrl = "image_url"
        case userId = "user_id"
        case id, score
    }
}
