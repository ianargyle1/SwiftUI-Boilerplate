//
//  UserModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/14/24.
//

import Foundation

struct User: Codable, Hashable, Identifiable {
    var id: Int
    var first_name: String
    var last_name: String
    var email: String
}
