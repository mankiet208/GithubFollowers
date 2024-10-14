//
//  UIViewController+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 27/09/2024.
//

import UIKit

extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyView = GFEmptyStateView(message: message)
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func push(_ vc: UIViewController, animated: Bool = true, hideBottomBar: Bool = false) {
        vc.hidesBottomBarWhenPushed = hideBottomBar
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popTo(to vc: AnyClass, animated: Bool = true) {
        if let vc = navigationController?.viewControllers.filter({$0.isKind(of: vc)}).last {
            navigationController?.popToViewController(vc, animated: animated)
        }
    }
}
