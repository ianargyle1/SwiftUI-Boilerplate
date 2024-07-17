//
//  NetworkError.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/17/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case authenticationError
}
