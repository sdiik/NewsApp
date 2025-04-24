//
//  AuthServiceTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import XCTest
@testable import NewsApp

final class AuthServiceTests: XCTestCase {

    func testDecodeValidJWT() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
                  "eyJuaWNrbmFtZSI6ImpvaG5kb2UiLCJlbWFpbCI6ImpvaG5kb2VAZXhhbXBsZS5jb20ifQ." +
                  "signature-placeholder"

        let authService = AuthService()
        let payload = decode(jwtToken: jwt)

        XCTAssertEqual(payload["nickname"] as? String, "johndoe")
        XCTAssertEqual(payload["email"] as? String, "johndoe@example.com")
    }

    func testDecodeInvalidJWT() {
        let jwt = "invalid.token.value"
        let authService = AuthService()
        let payload = decode(jwtToken: jwt)

        XCTAssertTrue(payload.isEmpty)
    }

    func testDecodeJWTWithMissingPayloadSegment() {
        let jwt = "onlyonepart"
        let authService = AuthService()
        let payload = decode(jwtToken: jwt)

        XCTAssertTrue(payload.isEmpty)
    }
}
