//
//  InfoRepositoryImpl.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

class InfoRepositoryImpl: InfoRepository {
    let networkService: NetworkRepository
    
    init(networkService: NetworkRepository = NetworkRepositoryImpl(session: SSLSessionFactory.makePinnedSession())) {
        self.networkService = networkService
    }
    
    func getInfo(completion: @escaping InfoItemsResult) {
        guard let url = NewsAPIService().makeInfoURL() else { return }
        
        networkService.fetchRequest(url) { networkResult in
            switch networkResult {
            case .success(let response):
                let (urlResponse, data) = response
                guard urlResponse.statusCode.isOk else {
                    completion(.failure(.loading))
                    return
                }
                self.parse(data: data, result: completion)
            case .failure(let error):
                completion(.failure(.loading))
           }
        }
    }
    
    private func parse(data: Any, result: @escaping InfoItemsResult) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let decoder = JSONDecoder()
            let blogResponse = try decoder.decode(InfoResponse.self, from: jsonData)
            result(.success(blogResponse))
        } catch {
            result(.failure(.parsing))
        }
    }
}
