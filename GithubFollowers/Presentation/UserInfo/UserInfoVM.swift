//
//  UserInfoVM.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 14/10/2024.
//

import Foundation
import Combine

class UserInfoVM: BaseVM {
    
    @Published private(set) var user: User?
    
    private let username: String
    private let userRepository: UserRepository

    init(
        username: String,
        userRepository: UserRepository
    ) {
        self.username = username
        self.userRepository = userRepository
    }
    
    func fetchInfo() {
        fetchUserInfo(username: username)
    }
}

extension UserInfoVM {
    
    private func fetchUserInfo(username: String) {
        state = .loading

        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.state = .error(error.localizedDescription)
            case .finished:
                self?.state = .loaded
            }
        }
        let valueHandler: (User) -> Void = { [weak self] user in
            guard let self = self else {
                return
            }
            self.user = user
        }

        userRepository.fetchUserInfo(username: username)
            .sink(
                receiveCompletion: completionHandler,
                receiveValue: valueHandler
            )
            .store(in: &bindings)
    }
}
