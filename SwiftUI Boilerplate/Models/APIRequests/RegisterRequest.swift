//
//  RegisterRequest.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 9/13/24.
//

import Foundation

struct RegisterRequest: Codable {
    var first_name: String
    var last_name: String
    var email: String
    var password: String
}
