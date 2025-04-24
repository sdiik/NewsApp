//
//  RecentSearchManagerTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import XCTest
@testable import NewsApp

class RecentSearchManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        RecentSearchManager.shared.clear()
    }
    
    override func tearDown() {
        RecentSearchManager.shared.clear()
        super.tearDown()
    }
    
    func testSaveSearchTerm() {
        let searchTerm = "NASA"
        RecentSearchManager.shared.save(searchTerm: searchTerm)
        
        let searches = RecentSearchManager.shared.getSearches()
        XCTAssertEqual(searches.count, 1)
        XCTAssertEqual(searches.first, searchTerm)
    }
    
    func testSaveMultipleSearchTerms() {
        RecentSearchManager.shared.save(searchTerm: "NASA")
        RecentSearchManager.shared.save(searchTerm: "SpaceX")
        RecentSearchManager.shared.save(searchTerm: "Mars Rover")
        
        let searches = RecentSearchManager.shared.getSearches()
        XCTAssertEqual(searches.count, 3)
        XCTAssertEqual(searches.first, "Mars Rover")
        XCTAssertEqual(searches.last, "NASA")
    }
    
    func testSaveDuplicateSearchTerm() {
        RecentSearchManager.shared.save(searchTerm: "NASA")
        RecentSearchManager.shared.save(searchTerm: "NASA")
        
        let searches = RecentSearchManager.shared.getSearches()
        XCTAssertEqual(searches.count, 1)
        XCTAssertEqual(searches.first, "NASA")
    }
    
    func testClearSearches() {
        RecentSearchManager.shared.save(searchTerm: "NASA")
        RecentSearchManager.shared.save(searchTerm: "SpaceX")
        
        var searches = RecentSearchManager.shared.getSearches()
        XCTAssertEqual(searches.count, 2)
        
        RecentSearchManager.shared.clear()
        searches = RecentSearchManager.shared.getSearches()
        XCTAssertEqual(searches.count, 0)
    }
}
