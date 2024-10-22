//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 21/10/2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

struct PersistenceManager {
    
    enum Keys {
       static let favorites = "favorites"
    }
    
    private init() {}
    
    static private let defaults = UserDefaults.standard
    
    static func update(favorite: Follower,
                       with actionType: PersistenceActionType,
                       completion: (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    
                    retrievedFavorites.append(favorite)
                case .remove:
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                let saveErr = saveFavorites(favorites: retrievedFavorites)
                
                completion(saveErr)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveFavorites(completion: (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let followers = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(followers))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func saveFavorites(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
