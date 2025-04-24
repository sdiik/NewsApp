//
//  InfoUseCase.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

typealias InfoUseCaseCompletionHandler = (_ result: Result<InfoResponse, InfoError>) -> Void

protocol InfoUseCase {
    func execute(completionHandler: @escaping InfoUseCaseCompletionHandler)
}
