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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.githubLogo
        return imageView
    }()

    private let usernameTextField = GFTextField()
    private let actionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    private var logoTopConstraint: NSLayoutConstraint!

    private var isUsernameEntered: Bool {
        return !(usernameTextField.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(logoImageView, usernameTextField, actionButton)
        configureLogoImageView()
        configureTextField()
        configureButton()
        createDismissKeyboardGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameTextField.text = ""
    }

    private func createDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tapGesture)
    }

    private func configureLogoImageView() {
        let topContraint: CGFloat = DeviceTypes.isiPhoneSEGen3rd ? 40 : 80
        
        logoTopConstraint = logoImageView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: topContraint
        )
        logoTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func configureTextField() {
        usernameTextField.delegate = self

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureButton() {
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
        
        usernameTextField.resignFirstResponder()

        let followerListVC = FollowerListVC.createInstance(with: usernameTextField.text!)
        show(followerListVC, sender: self)
    }
}

extension SearchVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
