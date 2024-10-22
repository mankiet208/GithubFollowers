//
//  GFError.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 21/10/2024.
//

import Foundation

enum GFError: String, Error {
    case unableToFavorite = "There was an error favoriting this user. Please try again later."
    case alreadyInFavorites = "You've already favorited this user."
}
