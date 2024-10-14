//
//  Query.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation

struct PageQuery: Codable {
    var page: Int
    var perPage: Int
    
    init(page: Int = 1, perPage: Int = 30) {
        self.page = page
        self.perPage = perPage
    }
}

struct FollowerQuery: Codable {
    var username: String
    var paging: PageQuery
    
    init(username: String, paging: PageQuery = PageQuery()) {
        self.username = username
        self.paging = paging
    }
}
