//
//  AuthRepositoryTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import XCTest
@testable import NewsApp

class AuthRepositoryTests: XCTestCase {
    var authRepository: AuthRepositoryImpl!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        authRepository = AuthRepositoryImpl(authService: mockAuthService)
    }
    
    override func tearDown() {
        authRepository = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    func testLogin_Success() {
        mockAuthService.shouldReturnError = false
        
        let expectation = self.expectation(description: "Login should succeed")
        
        authRepository.login(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let credentials):
                XCTAssertEqual(credentials.accessToken, "mockAccessToken")
                XCTAssertEqual(credentials.idToken, "mockIdToken")
            case .failure:
                XCTFail("Login should succeed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLogin_Failure() {
        mockAuthService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Login should fail")
        
        authRepository.login(email: "test@example.com", password: "wrongPassword") { result in
            switch result {
            case .success:
                XCTFail("Login should fail")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Login Failed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRegister_Success() {
        mockAuthService.shouldReturnError = false
        
        let expectation = self.expectation(description: "Register should succeed")
        
        authRepository.register(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let credentials):
                XCTAssertEqual(credentials.accessToken, "mockAccessToken")
                XCTAssertEqual(credentials.idToken, "mockIdToken")
            case .failure:
                XCTFail("Registration should succeed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRegister_Failure() {
        mockAuthService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Register should fail")
        
        authRepository.register(email: "test@example.com", password: "short") { result in
            switch result {
            case .success:
                XCTFail("Registration should fail")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Registration Failed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
