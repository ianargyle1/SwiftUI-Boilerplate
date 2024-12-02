//
//  AppleLoginRequest.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 9/26/24.
//

import Foundation

struct AppleLoginRequest: Codable {
    var first_name: String?
    var last_name: String?
    var email: String?
    var apple_id: String
    var token: String
}
