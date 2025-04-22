//
//  NetworkRepositoryTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import XCTest
@testable import NewsApp

final class NetworkRepositoryTests: XCTestCase {
    func testLoadNewsSuccess() {
        let mockRepo = MockNetworkRepository()
        mockRepo.shouldSucceed = true
        mockRepo.responseData = "Hello, Shiddiq!".data(using: .utf8)!
        
        let sut = NewsFetcher(repo: mockRepo)
        let expectation = self.expectation(description: "Success completion called")
        
        sut.loadNews { message in
            XCTAssertEqual(message, "Hello, Shiddiq!")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadNewsFailure() {
        let mockRepo = MockNetworkRepository()
        mockRepo.shouldSucceed = false
        
        let sut = NewsFetcher(repo: mockRepo)
        let expectation = self.expectation(description: "Failure completion called")
        
        sut.loadNews { message in
            XCTAssertEqual(message, "Fetch Failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
