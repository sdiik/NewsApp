//
//  StringExtensionTest.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import XCTest
@testable import NewsApp

class StringExtensionTest: XCTestCase {
    
    func testGetSummarySentence() {
        let summary = "NASA’s overall science budget in the FY25 request is nearly $1 billion less than what the agency expected last year it would have available. While MSR’s problems has attracted the most attention, the pain is being felt across the science mission directorate."
        let summarySentence = StringUtils.getSummarySentence(from: summary)
        let expectedSentence = "NASA’s overall science budget in the FY25 request is nearly $1 billion less than what the agency expected last year it would have available"
        XCTAssertEqual(summarySentence, expectedSentence, "Summary sentence should match the first sentence before the period.")
    }
    
    func testFormatDate_withInvalidDateString() {
        let dateString = "invalid-date"
        let formattedDate = StringUtils.formatDate(dateString)
        
        XCTAssertEqual(formattedDate, dateString, "Invalid date string should return the same string")
    }
    
    func testGetSummarySentence_withValidSummary() {
        let summary = "NASA’s overall science budget in the FY25 request is nearly $1 billion less than what the agency expected last year it would have available. While MSR’s problems have attracted the most attention."
        let sentence = StringUtils.getSummarySentence(from: summary)
        
        let expectedSentence = "NASA’s overall science budget in the FY25 request is nearly $1 billion less than what the agency expected last year it would have available"
        
        XCTAssertEqual(sentence, expectedSentence, "Summary sentence should match the expected sentence")
    }
    
    func testGetSummarySentence_withEmptySummary() {
        let summary = ""
        let sentence = StringUtils.getSummarySentence(from: summary)
        
        XCTAssertEqual(sentence, "", "Empty summary should return an empty string")
    }
    
    func testGetSummarySentence_withSingleSentenceSummary() {
        let summary = "This is a single sentence."
        let sentence = StringUtils.getSummarySentence(from: summary)
        
        let expectedSentence = "This is a single sentence"
        
        XCTAssertEqual(sentence, expectedSentence, "Single sentence summary should return the same sentence")
    }
}
