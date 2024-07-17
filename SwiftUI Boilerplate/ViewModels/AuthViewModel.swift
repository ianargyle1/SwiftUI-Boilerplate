//
//  AuthViewModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/17/24.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var jwtPayload: JWTPayload?
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        AuthService.shared.$jwt
            .receive(on: RunLoop.main)
            .compactMap { jwt -> JWTPayload? in
                guard let jwt = jwt, let payload = AuthService.decodeJWT(jwt) else { return nil }
                print("SDFSDIJGHIU-----------------")
                print(payload)
                return payload
            }
            .assign(to: \.jwtPayload, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        AuthService.shared.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcyMTI1MzYwOSwianRpIjoiYWFmNWY5M2QtOTdhMS00ZDlhLWJiMjEtMzdhZDVjYjU3NDViIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6MiwibmJmIjoxNzIxMjUzNjA5LCJjc3JmIjoiYWIzNjVkNjktNGIzNS00NDA5LTlkYjYtMmRjOTU3YzRmZGNhIiwiZXhwIjoxNzIxMjU0NTA5fQ.AnB3LUuaTAlB7s7ZQlubka_qwF2-zi19a70qNleMkFE"
    }
}
