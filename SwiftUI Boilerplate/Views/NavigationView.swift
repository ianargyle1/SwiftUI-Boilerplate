//
//  NavigationView.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/14/24.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var authService = AuthService.shared
    
    var body: some View {
        if (authService.token != nil) {
            UserView()
        } else {
            NavigationStack {
                LoginView()
            }
        }
    }
}

#Preview {
    NavigationView()
}
