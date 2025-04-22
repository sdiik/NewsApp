//
//  SLLPanningTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import XCTest
import Alamofire
@testable import NewsApp

final class SLLPanningTests: XCTestCase {
    
    func testSSL_Pinning_Success() {
        let expectation = self.expectation(description: "Valid SSL certificate should pass")
        let repository = NetworkRepositoryImpl(session: SSLSessionFactory.makePinnedSession())
        
        let validURL = URL(string: "https://api.spaceflightnewsapi.net/v4/articles")!
        repository.fetchRequest(validURL) { result in
            switch result {
            case .success(let (response, _)):
                XCTAssertEqual(response.statusCode, 200)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got failure: \(error)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSSL_Pinning_Failure() {
        let expectation = self.expectation(description: "Invalid SSL should fail")
        let repository = NetworkRepositoryImpl(session: SSLSessionFactory.makePinnedSession())
        
        let invalidURL = URL(string: "https://www.apple.com")!
        
        repository.fetchRequest(invalidURL) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to SSL pinning mismatch")
            case .failure(let error):
                print("SSL pinning failed as expected: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
