//
//  LoginView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        VStack {
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
            .padding(.bottom, 20)
            BTButton(
                title: "Login",
                fullWidth: true,
                action: { viewModel.login() },
                disabled: .constant(!viewModel.isValid)
            )
        }
        .padding(30)
    }
}

#Preview {
    LoginView()
}
