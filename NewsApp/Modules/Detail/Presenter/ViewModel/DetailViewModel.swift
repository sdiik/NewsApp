//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

protocol DetailDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailWithError(_ error: Error)
    func didDetail()
}

class DetailViewModel {
    var delegate: DetailDelegate?
    private let detailUseCase: DetailUseCase
    
    var id: Int?
    var detailType: DetailType?
    var detail: Blog?
    
    init(detailUseCase: DetailUseCase = DetailUseCaseImpl()) {
        self.detailUseCase = detailUseCase
    }
    
    func getDetailNews() {
        delegate?.didStartLoading()
        guard let id = id, let detailType = detailType else { return }
        detailUseCase.execute(with: id, detailType: detailType) { result in
            self.delegate?.didFinishLoading()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.detail = response
                    self.delegate?.didDetail()
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
}
