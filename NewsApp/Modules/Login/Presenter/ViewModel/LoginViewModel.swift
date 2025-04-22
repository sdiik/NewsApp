//
//  LoginViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

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
        loginUseCase.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.delegate?.loginSuccess()
            case .failure(let error):
                self.delegate?.loginFailed(with: error.localizedDescription)
            }
            delegate?.isLoading(status: false)
        }
        
    }
}
