//
//  GFAlertVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 28/09/2024.
//

import UIKit

class GFAlertVC: UIViewController {
    
    let containerView = GFAlertContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(backgroundColor: .systemPink, title: "OK")
    
    let PADDING: CGFloat = 20
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var buttonAction: (() -> Void)?
    
    init(alertTitle: String, message: String, buttonTitle: String, buttonAction: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.addSubviews(containerView, titleLabel, messageLabel, actionButton)
        
        configureContainer()
        configureTitleLabel()
        configureMessageLabel()
        configureActionButton()
    }
    
    func configureContainer() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "???"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: PADDING),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: PADDING),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -PADDING),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureMessageLabel() {
        messageLabel.text = message ?? "Something wen wrong!"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: PADDING),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -PADDING),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -8)
        ])
    }
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -PADDING),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: PADDING),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -PADDING),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func didTapButton() {
        dismiss(animated: true)
        buttonAction?()
    }
}
