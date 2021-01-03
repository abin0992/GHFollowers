//
//  GFUserListViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFUserListViewController: UIViewController {

    @IBOutlet weak var usersCollectionView: UICollectionView!

    var username: String!
    var users: [User] = []
    var page: Int = 1
    var hasMoreUsers: Bool = true
    var isSearching: Bool = false
    var isFollwersList: Bool = false
    var isLoadingMoreusers: Bool = false
    lazy var dataSource: DataSource = makeDataSource()
    var emptyStateView: UIView?
    let displayUserInfoSegueIdentifier: String = "showUserInfoSegue"
    let reuseIdentifier: String = "userCell"
    var networkService: GFService = GFService()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, User>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User>

    enum Section { case main }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let mainStoryboard: UIStoryboard = storyboard {
            emptyStateView = mainStoryboard.instantiateViewController(withIdentifier: GFEmptyStateViewController.className).view
        }
        view.accessibilityIdentifier = AccessibilityIdentifier.userListView.rawValue
        usersCollectionView.accessibilityIdentifier = AccessibilityIdentifier.userListCollectionView.rawValue
        configureCollectionView()
        fetchUsers(username: username, page: page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    // MARK: - API call

    typealias OptionalCompletionClosure = (() -> Void)?

    func fetchUsers(username: String, page: Int, completion: OptionalCompletionClosure = nil) {
        showLoadingView()
        isLoadingMoreusers = true

        networkService.fetchUsers(for: username, page: page) { [weak self] result in

            guard let self = self else {
                return
            }
            self.dismissLoadingView()

            switch result {
            case .success(let users):
                self.updateUI(with: users)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: Alert.errorTitle, message: error.description, buttonTitle: Alert.okButtonLabel)
            }

            self.isLoadingMoreusers = false
        }
    }

    // MARK: - Private functions

    private func configureNavigationBar() {
        self.title = username
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        usersCollectionView.delegate = self
        usersCollectionView.backgroundColor = .systemBackground
        usersCollectionView.collectionViewLayout = createThreeColumnFlowLayout()
    }

    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width: CGFloat = self.view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth: CGFloat = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth: CGFloat = availableWidth / 3

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }

    private func makeDataSource() -> DataSource {
        let dataSource: DataSource = DataSource(collectionView: usersCollectionView) { collectionView, indexPath, user -> UICollectionViewCell? in
            let cell: GFUserCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? GFUserCell ?? GFUserCell()
            cell.set(user: user)
            return cell
        }
        return dataSource
    }

    private func updateUI(with users: [User]) {
        if users.count < 100 { self.hasMoreUsers = false }
        self.users.append(contentsOf: users)

        if self.users.isEmpty {
            DispatchQueue.main.async {
                self.usersCollectionView.backgroundView = self.emptyStateView
            }
            return
        }

        self.updateData(on: self.users)
    }

    func updateData(on users: [User]) {
        var snapshot: NSDiffableDataSourceSnapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - Collection View Delegate

extension GFUserListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.accessibilityIdentifier = AccessibilityIdentifier.userCell.rawValue
        if indexPath.item == users.count - 1 {
            guard hasMoreUsers, !isLoadingMoreusers else {
                return
            }
            page += 1
            if isFollwersList {
                fetchFollowers(username: username, page: page)
            } else {
                fetchUsers(username: username, page: page)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let user: User = users[indexPath.item]

        if let mainStoryboard: UIStoryboard = storyboard {
            let destinationViewController: GFUserInfoViewController = mainStoryboard.instantiateViewController(identifier: GFUserInfoViewController.className) as GFUserInfoViewController
            destinationViewController.username = user.login
            destinationViewController.delegate = self
            let navigationController: UINavigationController = UINavigationController(rootViewController: destinationViewController)

            self.present(navigationController, animated: true)
        }
    }
}

// MARK: User info screen delegate

extension GFUserListViewController: UserInfoVCDelegate {
    func didRequestUsers(for username: String) {
        self.username = username
        title = "Followers List"
        page = 1
        hasMoreUsers = true
        users.removeAll()
        usersCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        fetchFollowers(username: username, page: page)
    }

    func fetchFollowers(username: String, page: Int, completion: OptionalCompletionClosure = nil) {
        showLoadingView()
        isLoadingMoreusers = true

        networkService.fetchFollowers(for: username, page: page) { [weak self] result in

            guard let self = self else {
                return
            }
            self.dismissLoadingView()

            switch result {
            case .success(let followers):
                self.updateUI(with: followers)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: Alert.errorTitle, message: error.description, buttonTitle: Alert.okButtonLabel)
            }

            self.isLoadingMoreusers = false
        }
    }
}
