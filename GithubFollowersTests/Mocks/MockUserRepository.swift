//
//  MockUserRepo.swift
//  GithubFollowersTests
//
//  Created by Kiet Truong on 21/10/2024.
//

import Foundation
import Combine
@testable import GithubFollowers

final class MockUserRepository: UserRepository {
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func fetchFollowerList(query: GithubFollowers.FollowerQuery) -> AnyPublisher<[GithubFollowers.Follower], Error> {
        return userService.fetchFollowerList(query: query)
    }
    
    func fetchUserInfo(username: String) -> AnyPublisher<GithubFollowers.User, Error> {
        return userService.fetchUserInfo(username: username)
    }
}
