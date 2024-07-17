//
//  APIRequestModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/17/24.
//

import Foundation

struct APIRequest {
    var path: String
    var method: HTTPMethod
    var headers: [String: String]?
    var urlParams: [String: String]?
    var body: Data?

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    init(path: String, method: HTTPMethod, headers: [String: String]? = nil, urlParams: [String: String]? = nil, body: Data? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.urlParams = urlParams
        self.body = body
    }
}
