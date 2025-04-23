//
//  LoginViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//


import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        loadingView.color = UIColor.orange
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.orange
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 20
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        registerButton.setTitleColor(UIColor.orange, for: .normal)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            Alert.showMessage(with: "Please input email and passwor", controller: self)
            return
        }
        loginViewModel.login(email: email, password: password)
    }

    @objc private func registerTapped() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}


extension LoginViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case passwordTextField:
            if Validation.isValidPassword(text) {
                errorPasswordLabel.isHidden = true
            } else {
                errorPasswordLabel.isHidden = false
                errorPasswordLabel.text = "Password must be 8+ characters, incl. uppercase, number, symbol"
                
            }
        case emailTextField:
            if Validation.isValidEmail(text) {
                errorEmailLabel.isHidden = true
            } else {
                errorEmailLabel.isHidden = false
                errorEmailLabel.text = "Please enter a valid email address"
            }
        default:
            break
        }
        setupLoginButton()
    }

    private func setupLoginButton() {
        guard errorEmailLabel.isHidden, errorPasswordLabel.isHidden else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
}

extension LoginViewController: LoginViewDelegate {
    func isLoading(status: Bool) {
       DispatchQueue.main.async {
           self.loadingView.isHidden = !status
           status ? self.loadingView.startAnimating() : self.loadingView.stopAnimating()
        }
    }
    
    func loginSuccess() {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        }
        
    }
    
    func loginFailed(with message: String) {
        Alert.showMessage(with: "\(message)", controller: self)
    }
}
