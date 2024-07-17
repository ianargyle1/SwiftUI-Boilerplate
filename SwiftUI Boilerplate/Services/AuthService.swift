//
//  AuthService.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/15/24.
//

import Foundation
import KeychainAccess
import JWTDecode

class AuthService: ObservableObject {
    static let shared = AuthService()
    private let keychain = Keychain(service: "com.example.myapp")
    
    public static func decodeJWT(_ token: String?) -> JWTPayload? {
        guard token != nil,
              !token!.isEmpty,
              let jwt = try? decode(jwt: token!),
              let payloadData = try? JSONSerialization.data(withJSONObject: jwt.body),
              let payload = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
            return nil
        }
        return payload
    }
    
    public static func isExpired(_ token: String?) -> Bool {
        guard let payload = decodeJWT(token), Date() < Date(timeIntervalSince1970: payload.exp) else {
            return true
        }
        return false
    }

    @Published var jwt: String? {
        didSet {
            if let jwt = jwt {
                try? keychain.set(jwt, key: "jwt")
            } else {
                try? keychain.remove("jwt")
            }
        }
    }

    private init() {
        jwt = try? keychain.get("jwt")
    }
}

