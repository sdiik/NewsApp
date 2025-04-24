//
//  SortingHelperTests.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import XCTest
@testable import NewsApp

final class SortingHelperTests: XCTestCase {
    
    func testSortReportsByTitleAscending() {
        let blogs = [
            Blog(id: 1, title: "ISS Daily Summary Report – 7/25/2024", authors: [], url:"", imageUrl:"", newsSite: "NASA", summary: "", publishedAt: "", updatedAt: "", featured: false, launches: [], events: []),
            Blog(id: 1, title: "Starliner heads back to Earth", authors: [], url:"", imageUrl:"", newsSite: "NASA", summary: "", publishedAt: "", updatedAt: "", featured: false, launches: [], events: []),
            Blog(id: 1, title: "Boeing’s confidence remains high in Starliner’s return with crew", authors: [], url:"", imageUrl:"", newsSite: "NASA", summary: "", publishedAt: "", updatedAt: "", featured: false, launches: [], events: []),
        ]
        let sorted = sortReportsByTitle(blogs, ascending: true)
        XCTAssertEqual(sorted.map { $0.title }, ["Boeing’s confidence remains high in Starliner’s return with crew", "ISS Daily Summary Report – 7/25/2024", "Starliner heads back to Earth"])
    }
    
    func testSortReportsByTitleDescending() {
        let blogs = [
            Blog(id: 1, title: "ISS Daily Summary Report – 7/25/2024", authors: [], url:"", imageUrl:"", newsSite: "NASA", summary: "", publishedAt: "", updatedAt: "", featured: false, launches: [], events: []),
            Blog(id: 1, title: "Starliner heads back to Earth", authors: [], url:"", imageUrl:"", newsSite: "NASA", summary: "", publishedAt: "", updatedAt: "", featured: false, launches: [], events: []),
            Blog(id: 1, title: "Boeing’s confidence remains high in Starliner’s return with crew", authors: [], url:"", imageUrl:"", newsSite: "NASA", summary: "", publishedAt: "", updatedAt: "", featured: false, launches: [], events: []),
        ]
        let sorted = sortReportsByTitle(blogs, ascending: false)
        XCTAssertEqual(sorted.map { $0.title }, ["Starliner heads back to Earth", "ISS Daily Summary Report – 7/25/2024", "Boeing’s confidence remains high in Starliner’s return with crew",])
    }
}
 
