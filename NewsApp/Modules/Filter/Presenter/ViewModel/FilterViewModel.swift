//
//  FilterViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

protocol FilterDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailWithError(_ error: Error)
    func didInfo()
}

class FilterViewModel {
    var delegate: FilterDelegate?
    private let infoUseCase: InfoUseCase
    
    var onSelectNewsSite: ((String?) -> Void)?
    var selectedSite: String?
    private(set) var info: [String] = []
    
    init(infoUseCase: InfoUseCase = InfoUseCaseImpl()) {
        self.infoUseCase = infoUseCase
    }
    
    func getInfo() {
        delegate?.didStartLoading()
        infoUseCase.execute { result in
            self.delegate?.didFinishLoading()
            DispatchQueue.main.async { [ weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.info = response.newsSites
                    self.delegate?.didInfo()
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
}
