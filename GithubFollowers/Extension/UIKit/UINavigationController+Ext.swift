//
//  UINavigationController+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 09/10/2024.
//

import UIKit

extension UINavigationController {
    
    func applyBlurEffect() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
