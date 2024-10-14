//
//  UserRepository.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation
import Combine

protocol UserRepository {
    func fetchFollowerList(query: FollowerQuery) -> AnyPublisher<[Follower], Error>
    func fetchUserInfo(username: String) -> AnyPublisher<User, Error>
}

struct UserRepositoryImp: UserRepository {
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func fetchFollowerList(query: FollowerQuery) -> AnyPublisher<[Follower], Error> {
        return userService.fetchFollowerList(query: query)
    }
    
    func fetchUserInfo(username: String) -> AnyPublisher<User, Error> {
        return userService.fetchUserInfo(username: username)
    }
}
