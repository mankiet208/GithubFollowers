//
//  ItemInfoType.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import Foundation

enum ItemInfoType {
    case repos, gists, followers, following
}

extension ItemInfoType {
    
    var title: String {
        switch self {
        case .repos:
            return "Public Repos"
        case .gists:
            return "Public Gists"
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        }
    }
    
    var imageName: String {
        switch self {
        case .repos:
            return "folder"
        case .gists:
            return "text.alignleft"
        case .followers:
            return "person.2"
        case .following:
            return "heart"
        }
    }
}
