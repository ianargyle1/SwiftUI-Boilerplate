//
//  UserView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/31/24.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Current User: \(String(describing: viewModel.user))")
            BTButton(
                title: "Logout",
                fullWidth: true,
                action: { AuthService.shared.logout() }
            )
        }
        .padding(30)
    }
}

struct PreviewWrapper: View {
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        UserView().environmentObject(userViewModel)
    }
}

#Preview {
    PreviewWrapper()
}
