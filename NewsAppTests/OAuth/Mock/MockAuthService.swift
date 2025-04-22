//
//  MockAuthService.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import Foundation
@testable import NewsApp
import Auth0

class MockAuthService: AuthServiceProtocol {
    var shouldReturnError = false
    
    func login(email: String, password: String, completion: @escaping (Result<Credentials, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login Failed"])))
        } else {
            let mockCredentials = Credentials(accessToken: "mockAccessToken", idToken: "mockIdToken")
            completion(.success(mockCredentials))
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Credentials, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Registration Failed"])))
        } else {
            let mockCredentials = Credentials(accessToken: "mockAccessToken", idToken: "mockIdToken")
            completion(.success(mockCredentials))
        }
    }
}
