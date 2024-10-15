//
//  RepoItemVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import UIKit

class RepoItemVC: InfoItemVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }

    private func configureData() {
        itemInfoViewOne.bindData(with: .repos, count: user.publicRepos)
        itemInfoViewTwo.bindData(with: .gists, count: user.publicGists)
        
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    }
    
    @objc private func didTapAction() {
        delegate?.didTapGithubProfile(for: user)
    }
}
