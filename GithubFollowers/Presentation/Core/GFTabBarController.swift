//
//  RootVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 27/09/2024.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    func configure() {
        let searchNC = createSearchNC()
        let favoritesListNC = createFavoriteListNC()
        
        viewControllers = [searchNC, favoritesListNC]
        
        tabBar.tintColor = .systemGreen
        applyBlurEffect()
        UINavigationBar.appearance().tintColor = .systemGreen
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let searchNC = UINavigationController(rootViewController: searchVC)
       
        return searchNC
    }
    
    func createFavoriteListNC() -> UINavigationController {
        let favoriteListVM = FavoriteListVM()
        let favoritesListVC = FavoritesListVC(viewModel: favoriteListVM)
        favoritesListVC.title = "Favorite List"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let favoritesListNC = UINavigationController(rootViewController: favoritesListVC)
        
        return favoritesListNC
    }
}


