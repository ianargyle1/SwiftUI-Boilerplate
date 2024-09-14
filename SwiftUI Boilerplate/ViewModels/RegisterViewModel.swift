//
//  RegisterViewModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var firstNameError = ""
    @Published var lastName = ""
    @Published var lastNameError = ""
    @Published var email = ""
    @Published var emailError = ""
    @Published var password = ""
    @Published var passwordError = ""
    @Published var repeatPassword = ""
    @Published var repeatPasswordError = ""
    @Published var isValid = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $firstName
            .map { Validation.validateFirstName($0) }
            .assign(to: \.firstNameError, on: self)
            .store(in: &cancellables)
        
        $lastName
            .map { Validation.validateLastName($0) }
            .assign(to: \.lastNameError, on: self)
            .store(in: &cancellables)
        
        $email
            .map { Validation.validateEmail($0) }
            .assign(to: \.emailError, on: self)
            .store(in: &cancellables)
        
        $password
            .map { Validation.validatePassword($0) }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest($password, $repeatPassword)
            .map { Validation.validatePasswordsMatch($0, $1) }
            .assign(to: \.repeatPasswordError, on: self)
            .store(in: &cancellables)
        
        let fieldErrors = Publishers.CombineLatest4($firstNameError, $lastNameError, $emailError, $passwordError)
        
        fieldErrors
            .combineLatest($repeatPasswordError)
            .map { firstFour, repeatPasswordError in
                let (firstNameError, lastNameError, emailError, passwordError) = firstFour
                return firstNameError.isEmpty && lastNameError.isEmpty && emailError.isEmpty && passwordError.isEmpty && repeatPasswordError.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
    
    func register() {
        isLoading = true
        AuthService.shared.register(firstName: firstName, lastName: lastName, email: email, password: password) { [weak self] (error: Error?) in
            self?.isLoading = false
        }
    }
}
