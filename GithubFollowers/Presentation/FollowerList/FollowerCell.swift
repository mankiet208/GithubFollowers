//
//  FollowerCell.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 08/10/2024.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let identifier = "FollowerCell"
    
    private lazy var avatarImageView: GFAvatarImageView = {
        let imageView = GFAvatarImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var usernameLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 16)
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            //
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func bind(follower: Follower) {
        usernameLabel.text = follower.login
        
        Task { @MainActor in
            let image = await ImageCache.shared.loadImage(for: follower.avatarUrl)
            avatarImageView.image = image
        }
    }
}
