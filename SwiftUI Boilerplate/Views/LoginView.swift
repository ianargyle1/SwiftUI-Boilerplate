//
//  LoginView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
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
            BTSecureField(text: $viewModel.password, placeholder: "Password")
                .padding(.bottom, 20)
            BTButton(
                title: "Login",
                fullWidth: true,
                action: { viewModel.login() },
                disabled: .constant(
                    !viewModel.emailError.isEmpty ||
                    viewModel.password.isEmpty ||
                    viewModel.isLoading
                )
            )
        }
        .padding(30)
    }
}

#Preview {
    LoginView()
}
