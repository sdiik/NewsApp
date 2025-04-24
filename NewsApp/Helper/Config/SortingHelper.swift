//
//  SortingHelper.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

func sortReportsByTitle(_ reports: [Blog], ascending: Bool) -> [Blog] {
    return reports.sorted {
        ascending ? $0.title.lowercased() < $1.title.lowercased()
        : $0.title.lowercased() > $1.title.lowercased()
    }
}
