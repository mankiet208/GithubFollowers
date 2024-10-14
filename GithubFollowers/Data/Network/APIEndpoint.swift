//
//  NetworkManager.swift
//  TestApp
//
//  Created by Kiet Truong on 13/09/2024.
//

import Foundation

enum APIEndpoint {
    
    enum HttpMethod: String {
        case GET
        case POST
    }
    
    case getFollowers(query: FollowerQuery)
    case getUserInfo(username: String)
}

extension APIEndpoint {
    
    var path: String {
        switch self {
        case .getFollowers(let query):
            return "/users/\(query.username)/followers"
        case .getUserInfo(let username):
            return "/users/\(username)"
        }
    }
    
    var method: APIEndpoint.HttpMethod {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getFollowers(let query):
            var queryItems = [URLQueryItem]()
            queryItems.append(
                URLQueryItem(name: "page", value: "\(query.paging.page)")
            )
            queryItems.append(
                URLQueryItem(name: "per_page", value: "\(query.paging.perPage)")
            )
            return queryItems
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getFollowers(_), .getUserInfo(_):
            return ["accept": "application/vnd.github+json"]
        }
    }
}
