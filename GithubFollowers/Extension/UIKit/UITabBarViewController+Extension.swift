//
//  UITabBarViewController+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 09/10/2024.
//

import UIKit

extension UITabBarController {
    
    func applyBlurEffect() {
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
