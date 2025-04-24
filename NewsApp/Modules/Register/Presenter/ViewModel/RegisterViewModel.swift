//
//  RegisterViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation

protocol RegisterViewDelegate {
    func isLoading(status: Bool)
    func registerSuccess()
    func registerFailed(with message: String)
}

class RegisterViewModel {
    private let registerUseCase: RegisterUseCase
    var delegate: RegisterViewDelegate?
    
    init(registerUseCase: RegisterUseCase = RegisterUseCaseImpl()){
        self.registerUseCase = registerUseCase
    }
    
    func register(email: String, password: String) {
        delegate?.isLoading(status: true)
        registerUseCase.register(email: email, password: password) {  result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.isLoading(status: false)
                switch result {
                case .success(let data):
                    self.delegate?.registerSuccess()
                case .failure(let error):
                    self.delegate?.registerFailed(with: error.localizedDescription)
                }
                
            }
        }
        
    }
}
