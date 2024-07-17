//
//  RegisterView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
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
            .padding(.bottom, 10)
            BTSecureField(
                text: $viewModel.password,
                errorMessage: !viewModel.password.isEmpty ? $viewModel.passwordError : .constant(""),
                placeholder: "Repeat Password"
            )
            .padding(.bottom, 20)
            BTButton(
                title: "Login",
                fullWidth: true,
                action: {  },
                disabled: .constant(!viewModel.isValid)
            )
        }
        .padding(30)
    }
}

#Preview {
    RegisterView()
}
