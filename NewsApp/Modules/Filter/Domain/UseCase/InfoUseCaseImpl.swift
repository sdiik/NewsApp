//
//  InfoUseCaseImpl.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

class InfoUseCaseImpl: InfoUseCase {
    let infoRepository: InfoRepository
    
    init(infoRepository: InfoRepository = InfoRepositoryImpl()) {
        self.infoRepository = infoRepository
    }
    
    func execute(completionHandler: @escaping InfoUseCaseCompletionHandler) {
        infoRepository.getInfo { result in
            switch result {
            case .success(let newsResponse):
                completionHandler(.success(newsResponse))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
