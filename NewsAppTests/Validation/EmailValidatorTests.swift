//
//  EmailValidatorTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import XCTest
@testable import NewsApp

final class EmailValidatorTests: XCTestCase {
    func testValidEmails() {
        XCTAssertTrue(Validation.isValidEmail("example@test.com"))
        XCTAssertTrue(Validation.isValidEmail("user.name+alias@domain.co.id"))
    }

    func testInvalidEmails() {
        XCTAssertFalse(Validation.isValidEmail("example@"))
        XCTAssertFalse(Validation.isValidEmail("@example.com"))
        XCTAssertFalse(Validation.isValidEmail("plainaddress"))
    }
}
