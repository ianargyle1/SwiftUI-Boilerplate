//
//  Validation.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/11/24.
//

import Foundation

class Validation {
    static func validateEmail(_ email: String) -> String {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        if (!emailPredicate.evaluate(with: email)) {
            return INVALID_EMAIL_ADDRESS
        }
        return ""
    }
    
    static func validatePassword(_ password: String) -> String {
        if password.count < 8 {
            return PASSWORD_TOO_SHORT
        } else if password.count > 64 {
            return PASSWORD_TOO_LONG
        }
        return ""
    }
    
    static func validatePasswordsMatch(_ password1: String, _ password2: String) -> String {
        if password1 != password2 {
            return PASSWORDS_DONT_MATCH
        }
        return ""
    }
}
