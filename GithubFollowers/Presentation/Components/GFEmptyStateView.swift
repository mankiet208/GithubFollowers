//
//  GFEmptyStateView.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 09/10/2024.
//

import UIKit

class GFEmptyStateView: UIView {
    
    lazy private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty-state-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var messageLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 28)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    
    private func configure() {
        addSubview(logoImageView)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            //
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
}
