//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 14/10/2024.
//

import UIKit

class UserInfoVC: BaseVC {
    
    let PADDING: CGFloat = 20
    
    static func createInstance(with username: String) -> UserInfoVC {
        let userService = UserServiceImp()
        let userRepository = UserRepositoryImp(userService: userService)
        let userInfoVM = UserInfoVM(
            username: username,
            userRepository: userRepository
        )
        return UserInfoVC(viewModel: userInfoVM)
    }
    
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)
    private var itemViews: [UIView] = []
    
    weak var delegate: FollowerListVCDelegate?
        
    private let viewModel: UserInfoVM
    
    init(viewModel: UserInfoVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBinding()
        
        viewModel.fetchInfo()
    }

    override func configureVC() {
        super.configureVC()
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneAction)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction() {
        dismiss(animated: true)
    }
    
    private func configureUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
        }
                                                        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
            //
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: PADDING),
            itemViewOne.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            itemViewOne.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            //
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: PADDING),
            itemViewTwo.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            itemViewTwo.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            //
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: PADDING),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func configureBinding() {
        viewModel.$user
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard let self = self,
                      let user = user
                else { return }
                self.bindData(user: user)
            }
            .store(in: &bindings)
        
        viewModel.$state
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    self.showLoadingView()
                case .loaded, .error(_):
                    self.hideLoadingView()
                default: ()
                }            }
            .store(in: &bindings)
    }
    
    private func bindData(user: User) {
        self.add(UserInfoHeaderVC(user: user), to: self.headerView)

        let repoItemVC = RepoItemVC(user: user)
        repoItemVC.delegate = self
        self.add(repoItemVC, to: self.itemViewOne)

        let followerItemVC = FollowerItemVC(user: user)
        followerItemVC.delegate = self
        self.add(followerItemVC, to: self.itemViewTwo)
        
        self.dateLabel.text = "Github since \(user.createdAtFormatted)"
    }
}

extension UserInfoVC: InfoItemVCDelegate {
    
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlert(title: "Invalid URL",
                           message: "The url attached to this user is invalid.",
                           buttonTitle: "OK")
            return
        }
        openSafari(with: url, tintColor: nil)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlert(title: "No followers",
                           message: "The user has no followers.",
                           buttonTitle: "OK")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismiss(animated: true)
    }
}
