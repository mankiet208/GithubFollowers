//
//  MockUserService.swift
//  GithubFollowersTests
//
//  Created by Kiet Truong on 21/10/2024.
//

import Foundation
import Combine
@testable import GithubFollowers

final class MockUserService: UserService {
    var getCallsCount: Int = 0
    
    var getFetchFollowerListResult: Result<[Follower], Error> = .success([])
    
    
  
    func fetchFollowerList(query: FollowerQuery) -> AnyPublisher<[Follower], Error> {
        getCallsCount += 1
        
        return getFetchFollowerListResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchUserInfo(username: String) -> AnyPublisher<User, Error> {
        let mockUser = User(login: "test", avatarUrl: "", name: "test", location: "", bio: "", publicRepos: 10, publicGists: 12, followers: 45, following: 30, htmlUrl: "", createdAt: "")
        
        let result: Result<User, Error> = .success(mockUser)

        return result.publisher.eraseToAnyPublisher()
    }
}
