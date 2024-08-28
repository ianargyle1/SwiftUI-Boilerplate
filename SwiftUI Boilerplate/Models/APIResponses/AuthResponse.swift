//
//  AuthResponse.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/24/24.
//

import Foundation

struct AuthResponse: Codable {
    var token: String
    var refresh_token: String
}
