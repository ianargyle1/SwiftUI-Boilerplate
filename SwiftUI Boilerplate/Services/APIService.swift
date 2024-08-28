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

    func fetchData<RequestType: Codable, ResponseType: Codable>(with request: APIRequest<RequestType>, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        let fullPath = baseURL.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: fullPath)
        urlRequest.httpMethod = request.method.rawValue
        if let body = request.body {
            let encoder = JSONEncoder()
            do {
                urlRequest.httpBody = try encoder.encode(body)
                urlRequest.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        var authHeader: String?
        request.headers?.forEach { header in
            if header.key == "Authorization" {
                authHeader = header.value
            }
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let authHeader = authHeader {
            sessionConfiguration.httpAdditionalHeaders = [
                "Authorization": authHeader
            ]
        }

        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse, 401 == response.statusCode {
                    completion(.failure(NetworkError.authenticationError))
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(ResponseType.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    func fetchDataWithAuth<RequestType: Codable, ResponseType: Codable>(with request: APIRequest<RequestType>, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        var updatedRequest = request

        // Check if AuthService has a token and set it in the headers
        guard let token = AuthService.shared.token else {
            completion(.failure(NetworkError.authenticationError))
            return
        }
        
        // Ensure headers dictionary is initialized
        updatedRequest.headers = (updatedRequest.headers ?? [:])
        updatedRequest.headers?["Authorization"] = "Bearer \(token)"

        // Call fetchData function with the updated request
        fetchData(with: updatedRequest) { [weak self] (result: Result<ResponseType, Error>) in
            switch result {
            case .failure(let error):
                if let networkError = error as? NetworkError, networkError == .authenticationError {
                    // Handle authentication error by checking token expiration and refreshing token if needed
                    self?.handleAuthenticationError(with: updatedRequest, completion: completion)
                } else {
                    completion(.failure(error))
                }
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    private func handleAuthenticationError<RequestType: Codable, ResponseType: Codable>(with request: APIRequest<RequestType>, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        if AuthService.isExpired(AuthService.shared.refreshToken) {
            // If the refresh token is expired, log the user out
            AuthService.shared.logout()
            return
        }
        
        // Refresh the token
        AuthService.shared.refreshToken { [weak self] success in
            if success {
                // Retry the original request with the new token
                var retriedRequest = request
                
                // Update the request with the new token
                if let newToken = AuthService.shared.token {
                    retriedRequest.headers = (retriedRequest.headers ?? [:])
                    retriedRequest.headers?["Authorization"] = "Bearer \(newToken)"
                }
                
                // Retry the fetchData function
                self?.fetchData(with: retriedRequest, completion: completion)
            } else {
                // Something must be wrong with the users token, log them out to get a new one
                AuthService.shared.logout()
                completion(.failure(NetworkError.authenticationError))
            }
        }
    }
}



