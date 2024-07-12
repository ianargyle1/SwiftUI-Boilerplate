//
//  LoginViewViewModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import Combine
import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var emailError = ""
    @Published var password = ""
    @Published var passwordError = ""
    @Published var isValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $email
            .map { Validation.validateEmail($0) }
            .assign(to: \.emailError, on: self)
            .store(in: &cancellables)
        
        $password
            .map { Validation.validatePassword($0) }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest($emailError, $passwordError)
            .map { $0.isEmpty && $1.isEmpty }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        
    }
}
