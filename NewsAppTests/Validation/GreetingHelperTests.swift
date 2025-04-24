//
//  GreetingHelperTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import XCTest
@testable import NewsApp

final class GreetingHelperTests: XCTestCase {

    func testMorningGreeting() {
        let testDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let greeting = GreetingHelper.getGreeting(for: testDate)
        XCTAssertEqual(greeting, "Good morning")
    }

    func testAfternoonGreeting() {
        let testDate = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!
        let greeting = GreetingHelper.getGreeting(for: testDate)
        XCTAssertEqual(greeting, "Good afternoon")
    }

    func testEveningGreeting() {
        let testDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        let greeting = GreetingHelper.getGreeting(for: testDate)
        XCTAssertEqual(greeting, "Good evening")
    }

    func testNightGreeting() {
        let testDate = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        let greeting = GreetingHelper.getGreeting(for: testDate)
        XCTAssertEqual(greeting, "Good night")
    }

    func testLateNightGreeting() {
        let testDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: Date())!
        let greeting = GreetingHelper.getGreeting(for: testDate)
        XCTAssertEqual(greeting, "Good night")
    }
}
