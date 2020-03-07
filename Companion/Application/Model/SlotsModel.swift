//
//  SlotsModel.swift
//  Companion
//
//  Created by Viktor PELIVAN on 3/5/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Slot

struct Slots {
    var slots: [ComposedSlot?]
}

struct ComposedSlot {
    var slotArray: [Slot?]
    var beginAt: String?
    var endAt: String?
}

struct Slot: Decodable {
    let id: Int?
    let beginAt, endAt: String?
    let scaleTeam: Int? //Need to perform tests on this time
    let user: ClusterUser?

    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case scaleTeam = "scale_team"
        case user
    }
}
