//
//  LoginViewModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import Combine
import Foundation

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
}
