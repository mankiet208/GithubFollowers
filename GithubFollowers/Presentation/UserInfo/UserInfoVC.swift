//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 14/10/2024.
//

import UIKit

class UserInfoVC: BaseVC {
    
    static func createInstance(with username: String) -> UserInfoVC {
        let userService = UserServiceImp()
        let userRepository = UserRepositoryImp(userService: userService)
        let userInfoVM = UserInfoVM(
            username: username,
            userRepository: userRepository
        )
        return UserInfoVC(viewModel: userInfoVM)
    }
    
    private let viewModel: UserInfoVM
    
    init(viewModel: UserInfoVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureBinding()
        
        viewModel.fetchInfo()
    }

    private func configureNavBar() {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneAction)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction() {
        dismiss(animated: true)
    }
    
    private func configureBinding() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }

               print(state)
            }
            .store(in: &bindings)
    }
}
