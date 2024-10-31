//
//  ItemInfoType.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, followings
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
        case .followings:
            return "Following"
        }
    }
    
    var imageName: String {
        switch self {
        case .repos:
            return SFSymbols.repos
        case .gists:
            return SFSymbols.gists
        case .followers:
            return SFSymbols.followers
        case .followings:
            return SFSymbols.followings
        }
    }
}
