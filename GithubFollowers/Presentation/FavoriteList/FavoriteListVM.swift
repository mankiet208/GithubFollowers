//
//  FavoriteListVM.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 30/10/2024.
//

import Foundation

class FavoriteListVM: BaseVM {
    @Published private(set) var favorites: [Follower] = []
    @Published private(set) var error: String?

    func getFavorites() {
        error = nil
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                self.favorites = favorites
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func removeFavorite(at index: Int) {
        let removedFavorite = favorites.remove(at: index)

        PersistenceManager.update(favorite: removedFavorite, with: .remove) { error in
            if let err = error {
                self.error = err.rawValue
            }
        }
    }
    
    func resetError() {
        error = nil
    }
}
