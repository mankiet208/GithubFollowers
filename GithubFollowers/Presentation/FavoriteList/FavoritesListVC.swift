//
//  FavoritesListVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 27/09/2024.
//

import UIKit

class FavoritesListVC: BaseVC {
    
    enum Section {
        case main
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 80
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private var emptyView: GFEmptyStateView?
        
    private let viewModel: FavoriteListVM
        
    init(viewModel: FavoriteListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
    }
    
    override func configureVC() {
        super.configureVC()
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
    }
    
    private func configureBinding() {
        viewModel.$favorites
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] followers in
                guard let self = self else {
                    return
                }
                if followers.isEmpty {
                    let message = "You don't have any favorites. Go add some 👍."
                    self.showEmptyStateView(with: message, in: self.view)
                } else {
                    self.hideEmptyStateView()
                    self.tableView.reloadData()
                }
            }
            .store(in: &bindings)
        
        viewModel.$error
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                
                if let err = error {
                    self.presentGFAlert(
                        title: "Unable to remove",
                        message: err,
                        buttonTitle: "OK"
                    ) {
                        self.viewModel.resetError()
                    }
                }
            }
            .store(in: &bindings)
    }
    
    private func showEmptyStateView(with message: String, in view: UIView) {
        self.emptyView = GFEmptyStateView(message: message)
        emptyView!.frame = view.bounds
        view.addSubview(emptyView!)
    }
    
    private func hideEmptyStateView() {
        if emptyView != nil {
            emptyView?.removeFromSuperview()
            emptyView = nil
        }
    }
}

extension FavoritesListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier,
                                                 for: indexPath) as! FavoriteCell
        let favorite = viewModel.favorites[indexPath.row]
        cell.setData(favorite: favorite)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
                
        viewModel.removeFavorite(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

extension FavoritesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = viewModel.favorites[indexPath.row]
        let destVC = FollowerListVC.createInstance(with: favorite.login)
        
        show(destVC, sender: self)
    }
}
