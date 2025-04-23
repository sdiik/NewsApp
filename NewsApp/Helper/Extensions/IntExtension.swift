//
//  IntExtension.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

typealias HTTPStatusCode = Int

extension HTTPStatusCode {
    var isOk: Bool {
        return self >= 200 && self < 300
    }
}
