//
//  LoginView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI
import AuthenticationServices

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
            NavigationLink("Sign Up") {
                RegisterView()
                    .navigationBarBackButtonHidden(true)
            }
            .padding(.top, 20)
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        viewModel.loginWithApple(userCredential: userCredential)
                    }
                case .failure:
                    break
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(10)
            .padding(.top, 20)
            .disabled(viewModel.isLoading)
            
            Button(action: {}) {
                HStack {
                    Image(.google)
                        .resizable()
                        .frame(width: 17, height: 17)
                    Text("Sign in with Google")
                        .font(.system(size: 19, weight: .medium))
                }
              }
            .disabled(viewModel.isLoading)
            .frame(height: 50)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .cornerRadius(10)
        }
        .padding(30)
    }
}

#Preview {
    LoginView()
}
