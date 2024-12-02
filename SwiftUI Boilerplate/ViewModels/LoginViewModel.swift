//
//  LoginViewModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import Combine
import Foundation
import AuthenticationServices

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var emailError = ""
    @Published var password = ""
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $email
            .map { Validation.validateEmail($0) }
            .assign(to: \.emailError, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        isLoading = true
        AuthService.shared.login(email: email, password: password) { [weak self] (error: Error?) in
            self?.isLoading = false
        }
    }
    
    func loginWithApple(userCredential: ASAuthorizationAppleIDCredential) {
        isLoading = true
        AuthService.shared.loginWithApple(firstName: userCredential.fullName?.givenName, lastName: userCredential.fullName?.familyName, email: userCredential.email, appleId: userCredential.user, token: String(data: userCredential.identityToken!, encoding: .utf8)!) { [weak self] (error: Error?) in
            self?.isLoading = false
        }
    }
}
