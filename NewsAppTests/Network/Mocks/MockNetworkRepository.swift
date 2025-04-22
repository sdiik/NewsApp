//
//  MockNetworkRepository.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import XCTest
@testable import NewsApp

class MockNetworkRepository: NetworkRepository {
    var shouldSucceed: Bool = true
    var responseData: Data = "Mocked Success".data(using: .utf8)!
    var statusCode: Int = 200
    var error: Error = NSError(domain: "TestError", code: 999, userInfo: nil)
    
    func fetchRequest(_ url: URL, result: @escaping FetchRequestResult) {
        if shouldSucceed {
            let httpResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            result(.success((httpResponse, responseData)))
        } else {
            result(.failure(error))
        }
    }
}
