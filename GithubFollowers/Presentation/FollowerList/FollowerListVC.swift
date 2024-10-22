//
//  FollowerListVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 28/09/2024.
//

import UIKit
import Combine

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListVC: BaseVC {
    
    enum Section {
        case main
    }
    
    static func createInstance(with username: String) -> FollowerListVC {
        let userService = UserServiceImp()
        let userRepository = UserRepositoryImp(userService: userService)
        let followerListVM = FollowerListVM(
            username: username,
            userRepository: userRepository
        )
        return FollowerListVC(viewModel: followerListVM)
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionView.createThreeColumnFlowLayout(in: view)
        let clv = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: layout
        )
        clv.delegate = self
        clv.translatesAutoresizingMaskIntoConstraints = false
        return clv
    }()
    
    var emptyView: GFEmptyStateView?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
        
    private let viewModel: FollowerListVM
        
    init(viewModel: FollowerListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchController()
        configureDataSource()
        configureBinding()
        
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func configureVC() {
        super.configureVC()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAction)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func configureBinding() {
        viewModel.$followers
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] followers in
                guard let self = self else {
                    return
                }
                if followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 👍."
                    self.showEmptyStateView(with: message, in: self.view)
                } else {
                    self.hideEmptyStateView()
                }
                self.updateData(with: followers)
            }
            .store(in: &bindings)
        
        viewModel.$filteredFollowers
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] filteredFollowers in
                guard let self = self else {
                    return
                }
                if (filteredFollowers.isEmpty) {
                    self.updateData(with: self.viewModel.followers)
                } else {
                    self.updateData(with: filteredFollowers)
                }
            }
            .store(in: &bindings)
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    self.showLoadingView()
                case .loaded, .error(_):
                    self.hideLoadingView()
                default: ()
                }
            }
            .store(in: &bindings)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower in
                
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FollowerCell.identifier,
                for: indexPath
            ) as! FollowerCell
            
            cell.bind(follower: follower)
                            
            return cell
        })
    }
    
    private func updateData(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        dataSource.apply(snapshot, animatingDifferences: true)
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
    
    @objc private func addAction() {
        viewModel.addFavoriteUser()
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            viewModel.nextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let followers = viewModel.isSearching ? viewModel.filteredFollowers : viewModel.followers
        let selectedFollower = followers[indexPath.item]
        
        let userService = UserServiceImp()
        let userRepo = UserRepositoryImp(userService: userService)
        let userInfoVM = UserInfoVM(
            username: selectedFollower.login,
            userRepository: userRepo
        )
        let userInfoVC = UserInfoVC(viewModel: userInfoVM)
        userInfoVC.delegate = self
        
        let nav = UINavigationController(rootViewController: userInfoVC)
        
        showDetailViewController(nav, sender: self)
    }
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
        
        viewModel.updateSearchStatus(isSearching: true)

        if filter.isEmpty {
            viewModel.resetFilter()
        } else {
            viewModel.filterFollowers(with: filter)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.updateSearchStatus(isSearching: false)
        viewModel.resetFilter()
    }
}

extension FollowerListVC: FollowerListVCDelegate {
    
    func didRequestFollowers(for username: String) {
        title = username
        viewModel.setUsername(username)
        viewModel.resetAll()
        
        collectionView.setContentOffset(.zero, animated: true) // Scroll up
        
        viewModel.fetch()
    }
}
