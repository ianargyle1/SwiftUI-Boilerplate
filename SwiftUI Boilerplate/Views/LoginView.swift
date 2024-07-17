//
//  LoginView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                action: { authViewModel.login() },
                disabled: .constant(!viewModel.emailError.isEmpty || viewModel.password.isEmpty)
            )
        }
        .padding(30)
    }
}

#Preview {
    LoginView()
}
