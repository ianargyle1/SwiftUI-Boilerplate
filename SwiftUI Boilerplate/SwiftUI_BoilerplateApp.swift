//
//  SwiftUI_BoilerplateApp.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

@main
struct SwiftUI_BoilerplateApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView()
                .environmentObject(authViewModel)
        }
    }
}
