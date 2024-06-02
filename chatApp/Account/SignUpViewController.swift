//
//  SignUpViewController.swift
//  chatApp
//
//  Created by Радмир Тельман on 02.06.2024.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your details to create your account"
        label.textColor = UIColor(named: "nblack")
        label.font = UIFont(name: "mulish-bold", size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        return tf
    }()
    
    private lazy var continueSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "continue"), for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        view.addSubview(mainLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(continueSignInButton)
        
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func signInButtonTapped() {
        navigationController?.pushViewController(CreateAccountViewController(), animated: true)
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        continueSignInButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalToSuperview()
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setPlaceholder(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
