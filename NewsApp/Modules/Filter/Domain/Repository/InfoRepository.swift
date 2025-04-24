//
//  InfoRepository.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

typealias InfoItemsResult = (_ result: Result<InfoResponse, InfoError>) -> Void

protocol InfoRepository {
    func getInfo(completion: @escaping InfoItemsResult)
}
