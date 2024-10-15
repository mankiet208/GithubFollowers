//
//  FollowerItemVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import UIKit

class FollowerItemVC: InfoItemVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }
    
    private func configureData() {
        itemInfoViewOne.bindData(with: .followers, count: user.followers)
        itemInfoViewTwo.bindData(with: .following, count: user.following)
        
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    }
    
    @objc private func didTapAction() {
        delegate?.didTapGetFollowers(for: user)
    }
}
