//
//  JWTPayload.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/17/24.
//

import Foundation

struct JWTPayload: Codable {
    var sub: Int
    var exp: TimeInterval
}
