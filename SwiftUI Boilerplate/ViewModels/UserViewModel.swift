//
//  UserViewModel.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/22/24.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    private let BASE_PATH = "user"
    private var cancellables = Set<AnyCancellable>()
    @Published var user: User?
    @Published var error: Bool?

    init() {
        AuthService.shared.$token
            .receive(on: RunLoop.main)
            .sink { [weak self] token in
                self?.error = false
                if token != nil {
                    if self?.user == nil {
                        self?.fetchUserData()
                    }
                } else {
                    self?.user = nil
                }
            }
            .store(in: &cancellables)
    }

    private func fetchUserData() {
        let request = APIRequest<EmptyCodable>(
            path: BASE_PATH,
            method: .get
        )
        APIService.shared.fetchDataWithAuth(with: request) { [weak self] (result: Result<User, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResponse):
                    self?.error = false
                    self?.user = userResponse
                case .failure(let error):
                    self?.error = true
                    self?.user = nil
                }
            }
        }
    }
    
    func updateUser(newUser: User) {
        // Updating the user should be handled in this class
//        let request = APIRequest<User>(
//            path: BASE_PATH,
//            method: .patch,
//            body: newUser
//        )
//        APIService.shared.fetchDataWithAuth(with: request) { [weak self] (result: Result<User, Error>) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let userResponse):
//                    self?.user = userResponse
//                case .failure(let error):
//                    print("Failed to fetch user data: \(error)")
//                    self?.user = nil
//                }
//            }
//        }
    }
}

