//
//  FavoritesListVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 27/09/2024.
//

import UIKit

class FavoritesListVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

}
