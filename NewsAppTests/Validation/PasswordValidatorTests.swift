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
        XCTAssertTrue(isValidPassword("Password@232"))
        XCTAssertTrue(isValidPassword("Abcd5643!"))
        XCTAssertTrue(isValidPassword("Test@2343"))
    }
    
    func testShortPassword() {
        XCTAssertFalse(isValidPassword("P@aa9"))
    }
    
    func testNoUppercase() {
        XCTAssertFalse(isValidPassword("password@776"))
    }
    
    func testNoLowercase() {
        XCTAssertFalse(isValidPassword("PASSWORD@776"))
    }
    
    func testNoDigit() {
        XCTAssertFalse(isValidPassword("Password@"))
    }
    
    func testNoSpecialChar() {
        XCTAssertFalse(isValidPassword("Password343"))
    }
    
    func testEmptyString() {
        XCTAssertFalse(isValidPassword(""))
    }
}
