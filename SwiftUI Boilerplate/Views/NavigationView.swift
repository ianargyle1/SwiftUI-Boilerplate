//
//  NavigationView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/14/24.
//

import SwiftUI

struct NavigationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if (authViewModel.jwtPayload != nil) {
            Text("Current User: \(String(describing: authViewModel.jwtPayload))")
        } else {
            LoginView()
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @StateObject var authViewModel = AuthViewModel()
        
        var body: some View {
            NavigationView().environmentObject(authViewModel)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}

