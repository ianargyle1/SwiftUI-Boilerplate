//
//  APIService.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/16/24.
//

import Foundation

class APIService {
    static let shared = APIService()

    private let baseURL: URL

    private init() {
        guard let baseURLString = ProcessInfo.processInfo.environment["API_URL"],
              let url = URL(string: baseURLString) else {
            fatalError("API_URL environment variable is not set or is invalid.")
        }
        self.baseURL = url
    }

    func fetchData<T: Codable>(with request: APIRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let fullPath = baseURL.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: fullPath)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        request.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        guard let jwt = AuthService.shared.jwt, !jwt.isEmpty else {
            // CHECK EXPIRATION AND PERFORM REFRESH HERE
            completion(.failure(NetworkError.authenticationError))
            return
        }
        urlRequest.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


