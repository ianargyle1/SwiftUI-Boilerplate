//
//  AuthService.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/15/24.
//

import Foundation
import KeychainAccess
import JWTDecode
import Combine

// KEEP THIS OBSERVABLE
// If we discover that the token is expired in the APIService, and call the logout function,
// we need a way to know that the user has been logged FROM the the view/view model
class AuthService: ObservableObject {
    static let shared = AuthService()
    private let keychain = Keychain(service: "com.example.myapp")
    private let refreshQueue = DispatchQueue(label: "com.example.myapp.refreshQueue")
    private var isRefreshing = false
    private var refreshSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    // Decode JWT token
    public static func decodeJWT(_ jwt: String?) -> JWTPayload? {
        guard let jwt = jwt, !jwt.isEmpty,
              let jwtData = try? decode(jwt: jwt),
              let payloadData = try? JSONSerialization.data(withJSONObject: jwtData.body),
              let payload = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
            return nil
        }
        return payload
    }

    // Check if token is expired
    public static func isExpired(_ token: String?) -> Bool {
        guard let payload = decodeJWT(token), Date() < Date(timeIntervalSince1970: payload.exp) else {
            return true
        }
        return false
    }

    // Observe and store the token
    @Published private(set) var token: String? {
        didSet {
            if let token = token {
                try? keychain.set(token, key: "token")
            } else {
                try? keychain.remove("token")
            }
        }
    }

    // Observe and store the refresh token
    @Published private(set) var refreshToken: String? {
        didSet {
            if let refreshToken = refreshToken {
                try? keychain.set(refreshToken, key: "refreshToken")
            } else {
                try? keychain.remove("refreshToken")
            }
        }
    }

    // Private initializer to ensure singleton pattern
    private init() {
        token = try? keychain.get("token")
        refreshToken = try? keychain.get("refreshToken")
    }

    // Login a user
    public func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        let request = APIRequest<LoginRequest>(
            path: "auth/login",
            method: .post,
            body: LoginRequest(email: email, password: password)
        )

        APIService.shared.fetchData(with: request) { [weak self] (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let authResponse):
                DispatchQueue.main.async { // Ensure UI updates are on the main thread
                    self?.token = authResponse.token
                    self?.refreshToken = authResponse.refresh_token
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    // Login a user with apple credentials
    public func loginWithApple(firstName: String?, lastName: String?, email: String?, appleId: String, token: String, completion: @escaping (Error?) -> Void) {
        let request = APIRequest<AppleLoginRequest>(
            path: "auth/login-apple",
            method: .post,
            body: AppleLoginRequest(first_name: firstName, last_name: lastName, email: email, apple_id: appleId, token: token)
        )

        APIService.shared.fetchData(with: request) { [weak self] (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let authResponse):
                DispatchQueue.main.async { // Ensure UI updates are on the main thread
                    self?.token = authResponse.token
                    self?.refreshToken = authResponse.refresh_token
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    // Register a new user
    public func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        let request = APIRequest<RegisterRequest>(
            path: "auth/register",
            method: .post,
            body: RegisterRequest(first_name: firstName, last_name: lastName, email: email, password: password)
        )

        APIService.shared.fetchData(with: request) { [weak self] (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let authResponse):
                DispatchQueue.main.async { // Ensure UI updates are on the main thread
                    self?.token = authResponse.token
                    self?.refreshToken = authResponse.refresh_token
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    // Logout function
    public func logout() {
        token = nil
        refreshToken = nil
    }

    // Refresh token function
    public func refreshToken(completion: @escaping (Bool) -> Void) {
        refreshQueue.sync {
            if isRefreshing {
                refreshSubject
                    .sink(receiveValue: { success in
                        completion(success)
                    })
                    .store(in: &cancellables)
                return
            }

            isRefreshing = true
        }

        let request = APIRequest<EmptyCodable>(
            path: "auth/refresh",
            method: .post,
            headers: ["Authorization": "Bearer \(refreshToken ?? "")"],
            body: nil
        )

        APIService.shared.fetchData(with: request) { [weak self] (result: Result<AuthResponse, Error>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.refreshQueue.sync {
                    defer {
                        self.isRefreshing = false
                        self.refreshSubject.send(result.isSuccess)
                        self.refreshSubject = PassthroughSubject<Bool, Never>() // Reset subject for next use
                    }

                    switch result {
                    case .success(let authResponse):
                        self.token = authResponse.token
                        self.refreshToken = authResponse.refresh_token
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
            }
        }
    }
}

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}



