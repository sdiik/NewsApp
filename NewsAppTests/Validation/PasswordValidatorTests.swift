//
//  PasswordValidatorTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import XCTest
@testable import NewsApp

final class PasswordValidatorTests: XCTestCase {
    
    func testValidPasswords() {
        XCTAssertTrue(Validation.isValidPassword("Password@232"))
        XCTAssertTrue(Validation.isValidPassword("Abcd5643!"))
        XCTAssertTrue(Validation.isValidPassword("Test@2343"))
    }
    
    func testShortPassword() {
        XCTAssertFalse(Validation.isValidPassword("P@aa9"))
    }
    
    func testNoUppercase() {
        XCTAssertFalse(Validation.isValidPassword("password@776"))
    }
    
    func testNoLowercase() {
        XCTAssertFalse(Validation.isValidPassword("PASSWORD@776"))
    }
    
    func testNoDigit() {
        XCTAssertFalse(Validation.isValidPassword("Password@"))
    }
    
    func testNoSpecialChar() {
        XCTAssertFalse(Validation.isValidPassword("Password343"))
    }
    
    func testEmptyString() {
        XCTAssertFalse(Validation.isValidPassword(""))
    }
}
