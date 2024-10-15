//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 08/10/2024.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        image = placeholderImage
        layer.cornerRadius = 10
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fetchImage(from urlString: String) {
        Task { @MainActor in
            let image = await ImageCache.shared.loadImage(for: urlString)
            self.image = image ?? placeholderImage
        }
    }
}
