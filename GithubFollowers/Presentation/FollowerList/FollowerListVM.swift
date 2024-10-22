//
//  FollowerListVM.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation
import Combine

class FollowerListVM: BaseVM {
    
    @Published private(set) var followers: [Follower] = []
    @Published private(set) var filteredFollowers: [Follower] = []
    @Published private(set) var addFavoriteState: LoadState = .idle
    
    private var username: String
    private let userRepository: UserRepository
    
    private var currentQuery: FollowerQuery
    private var hasMoreFollowers: Bool = true
    private(set) var isSearching: Bool = false
    private var favoriteUser: User?
    
    init(
        username: String,
        userRepository: UserRepository
    ) {
        self.username = username
        self.userRepository = userRepository
        self.currentQuery = FollowerQuery(username: username)
    }
    
    func setUsername(_ username: String) {
        self.username = username
    }
    
    func fetch() {
        fetchFollowers(query: currentQuery)
    }
    
    func nextPage() {
        guard hasMoreFollowers else { return }
        currentQuery.paging.page += 1
        fetchFollowers(query: currentQuery)
    }
    
    func filterFollowers(with text: String) {
        filteredFollowers = followers.filter {
            $0.login.lowercased().contains(text.lowercased())
        }
    }
    
    func updateSearchStatus(isSearching: Bool) {
        self.isSearching = isSearching
    }
    
    func resetFilter() {
        filteredFollowers.removeAll()
    }
    
    func resetAll() {
        currentQuery = FollowerQuery(username: username)
        followers.removeAll()
        filteredFollowers.removeAll()
    }
    
    func addFavoriteUser() {
        getUserInfo(username: self.username) { [weak self] user in
            guard let self = self else {
                return
            }
            
            let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
            
            PersistenceManager.update(favorite: favorite, with: .add) { error in
                if let err = error {
                    print("[ERROR] \(err)")
                    return
                }
                
                print("[SUCCESS] Add favorite user \(self.username)")
            }
        }
    }
}

extension FollowerListVM {
    
    private func fetchFollowers(query: FollowerQuery) {
        state = .loading

        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                if let error = error as? APIError {
                    self?.state = .error(error.description)
                } else {
                    self?.state = .error(error.localizedDescription)
                }
            case .finished:
                self?.state = .loaded
            }
        }
        let valueHandler: ([Follower]) -> Void = { [weak self] items in
            guard let self = self else {
                return
            }
            if items.count < self.currentQuery.paging.perPage {
                self.hasMoreFollowers = false
            }
            self.followers.append(contentsOf: items)
        }

        userRepository.fetchFollowerList(query: query)
            .sink(
                receiveCompletion: completionHandler,
                receiveValue: valueHandler
            )
            .store(in: &bindings)
    }
    
    private func getUserInfo(username: String, completion: @escaping (User) -> Void)  {
        addFavoriteState = .loading
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                if let error = error as? APIError {
                    self?.addFavoriteState = .error(error.description)
                } else {
                    self?.addFavoriteState = .error(error.localizedDescription)
                }
            case .finished:
                self?.addFavoriteState = .loaded
            }
        }
        let valueHandler: (User) -> Void = { user in
            completion(user)
        }
        
        userRepository.fetchUserInfo(username: username)
            .sink(
                receiveCompletion: completionHandler,
                receiveValue: valueHandler
            )
            .store(in: &bindings)
    }
}
