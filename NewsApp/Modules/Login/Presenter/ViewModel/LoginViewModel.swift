//
//  LoginViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation

protocol LoginViewDelegate {
    func isLoading(status: Bool)
    func loginSuccess()
    func loginFailed(with message: String)
}

class LoginViewModel {
    private let loginUseCase: LoginUseCase
    var delegate: LoginViewDelegate?
    
    init(loginUseCase: LoginUseCase = LoginUseCaseImpl()){
        self.loginUseCase = loginUseCase
    }
    
    func login(email: String, password: String) {
        delegate?.isLoading(status: true)
        loginUseCase.login(email: email, password: password) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.isLoading(status: false)
                switch result {
                case .success(let data):
                    self.delegate?.loginSuccess()
                case .failure(let error):
                    self.delegate?.loginFailed(with: error.localizedDescription)
                }
            }
        }
    }
}
