//
//  UserInfoItemVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 14/10/2024.
//

import UIKit

protocol InfoItemVCDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class InfoItemVC: UIViewController {
    
    let PADDING: CGFloat = 20
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let itemInfoViewOne: GFItemInfoView = {
        let view = GFItemInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemInfoViewTwo: GFItemInfoView = {
        let view = GFItemInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let actionButton: GFButton = {
        let button = GFButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: InfoItemVCDelegate?
    
    var user: User!
    
    init(user: User!) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
        
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        
        actionButton.setContentCompressionResistancePriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: PADDING),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -PADDING),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            //
            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            actionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -PADDING),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
