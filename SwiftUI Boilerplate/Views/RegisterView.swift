//
//  RegisterView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                BTTextField(
                    text: $viewModel.firstName,
                    errorMessage: !viewModel.firstName.isEmpty ? $viewModel.firstNameError : .constant(""),
                    placeholder: "First Name"
                )
                BTTextField(
                    text: $viewModel.lastName,
                    errorMessage: !viewModel.lastName.isEmpty ? $viewModel.lastNameError : .constant(""),
                    placeholder: "Last Name"
                )
            }
            .padding(.bottom, 10)
            BTTextField(
                text: $viewModel.email,
                errorMessage: !viewModel.email.isEmpty ? $viewModel.emailError : .constant(""),
                placeholder: "Email Address"
            )
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding(.bottom, 10)
            BTSecureField(
                text: $viewModel.password,
                errorMessage: !viewModel.password.isEmpty ? $viewModel.passwordError : .constant(""),
                placeholder: "Password"
            )
            .padding(.bottom, 10)
            BTSecureField(
                text: $viewModel.repeatPassword,
                errorMessage: !viewModel.repeatPassword.isEmpty ? $viewModel.repeatPasswordError : .constant(""),
                placeholder: "Repeat Password"
            )
            .padding(.bottom, 20)
            BTButton(
                title: "Register",
                fullWidth: true,
                action: { viewModel.register() },
                disabled: .constant(!viewModel.isValid && !viewModel.isLoading)
            )
            Button("Sign In") {
                dismiss()
            }
            .padding(.top, 20)
        }
        .padding(30)
    }
}

#Preview {
    RegisterView()
}
