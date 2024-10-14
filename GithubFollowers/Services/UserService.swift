//
//  UserService.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation
import Combine

protocol UserService {
    func fetchFollowerList(query: FollowerQuery) -> AnyPublisher<[Follower], Error>
    func fetchUserInfo(username: String) -> AnyPublisher<User, Error>
}

struct UserServiceImp: UserService {
    
    func fetchFollowerList(query: FollowerQuery) -> AnyPublisher<[Follower], Error> {
        let endpoint: APIEndpoint = .getFollowers(query: query)
        let resposnse: AnyPublisher<[Follower], Error> = APIManager.shared.getData(from: endpoint)
        
        return resposnse
    }
    
    func fetchUserInfo(username: String) -> AnyPublisher<User, Error> {
        let endpoint: APIEndpoint = .getUserInfo(username: username)
        let resposnse: AnyPublisher<User, Error> = APIManager.shared.getData(from: endpoint)
        
        return resposnse
    }
}
