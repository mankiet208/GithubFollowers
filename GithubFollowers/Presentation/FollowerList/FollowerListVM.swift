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
    
    private var username: String
    private let userRepository: UserRepository
    
    private var currentQuery: FollowerQuery
    private var hasMoreFollowers: Bool = true
    private(set) var isSearching: Bool = false
    
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
}

extension FollowerListVM {
    
    private func fetchFollowers(query: FollowerQuery) {
        state = .loading

        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.state = .error(error.localizedDescription)
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

        userRepository
            .fetchFollowerList(query: query)
            .sink(
                receiveCompletion: completionHandler,
                receiveValue: valueHandler
            )
            .store(in: &bindings)
    }
}
