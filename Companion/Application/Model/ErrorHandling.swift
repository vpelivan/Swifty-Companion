//
//  ErrorHandling.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/4/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case noAccessToken
    case noJson
    case noData
}
