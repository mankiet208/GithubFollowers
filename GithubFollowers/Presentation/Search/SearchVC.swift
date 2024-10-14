//
//  SearchVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 27/09/2024.
//

import UIKit

class SearchVC: BaseVC {
    
    lazy private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gh-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameTextField = GFTextField()
    private let actionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    private var isUsernameEntered: Bool {
        return !(usernameTextField.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
        configureLogoImageView()
        configureTextField()
        configureButton()
        createDismissKeyboardGesture()
        
        usernameTextField.text = "Sallen0400"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func createDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
                
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func configureTextField() {
        view.addSubview(usernameTextField)
        
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        view.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlert(
                title: "Empty username",
                message: "Please enter a username. We need to know who to look for",
                buttonTitle: "OK"
            )
            return
        }
        
        if let username = usernameTextField.text {
            let followerListVC = FollowerListVC.createInstance(with: username)
            followerListVC.title = username
            
            show(followerListVC, sender: self)
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
