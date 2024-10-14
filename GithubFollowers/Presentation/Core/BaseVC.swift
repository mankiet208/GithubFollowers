//
//  BaseVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 08/10/2024.
//

import UIKit
import Combine

class BaseVC: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var loadingContainer: UIView!
    
    var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    func showLoadingView() {
        loadingContainer = UIView(frame: view.bounds)
        
        view.addSubview(loadingContainer)
        loadingContainer.addSubview(activityIndicator)
        
        loadingContainer.backgroundColor = .systemBackground
        loadingContainer.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.loadingContainer.alpha = 0.8
        }
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            self.loadingContainer.removeFromSuperview()
            self.loadingContainer = nil
        }
    }
}
