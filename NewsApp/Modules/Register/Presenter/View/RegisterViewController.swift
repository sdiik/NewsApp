//
//  RegisterViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var registerViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel.delegate = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = UIColor.orange
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.layer.cornerRadius = 20
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        loginButton.setTitleColor(UIColor.orange, for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func registerTapped() {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            Alert.showMessage(with: "Please input email and password", controller: self)
            return
        }
        registerViewModel.register(email: email, password: password)
    }
    
    private func setupRegisterButton() {
        guard errorEmailLabel.isHidden, errorPasswordLabel.isHidden else {
            registerButton.isEnabled = false
            return
        }
        registerButton.isEnabled = true
    }
}

extension RegisterViewController {
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
        setupRegisterButton()
    }
}

extension RegisterViewController: RegisterViewDelegate {
    func isLoading(status: Bool) {
        self.loadingView.isHidden = !status
        status ? self.loadingView.startAnimating() : self.loadingView.stopAnimating()
    }
    
    func registerSuccess() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    func registerFailed(with message: String) {
        Alert.showMessage(with: "\(message)", controller: self)
    }
}
