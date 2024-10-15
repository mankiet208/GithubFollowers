//
//  User.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let htmlUrl: String
    let createdAt: String
    
    var createdAtFormatted: String {
        guard let date = createdAt.convertToDate(with: DateFormatConstant.stantard) else {
            return "invalid_createdAt"
        }
        return date.convertToMonthYear(with: DateFormatConstant.monthYear)
    }
}
