//
//  GFUserListViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import Combine
import FeedEngine
import UIKit

class GFUserListViewController: UIViewController, Storyboardable {

    @IBOutlet weak var usersCollectionView: UICollectionView!

    var emptyStateView: UIView?
    let displayUserInfoSegueIdentifier: String = "showUserInfoSegue"
    let reuseIdentifier: String = "userCell"
    lazy var dataSource: DataSource = makeDataSource()

    lazy var viewModel: GFUserListViewModel = {
        let viewModel: GFUserListViewModel = GFUserListViewModel()
        return viewModel
    }()

    private var subscriptions: Set<AnyCancellable> = []

    var showUserInfo: ((String) -> Void)?

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
        viewModel.viewDidLoad()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    // MARK: - Private functions

    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingView()
                } else {
                    self?.dismissLoadingView()
                }
            }
            .store(in: &subscriptions)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if !message.isEmpty {
                    self?.presentGFAlertOnMainThread(title: Alert.errorTitle, message: message, buttonTitle: Alert.okButtonLabel)
                }
            }
            .store(in: &subscriptions)

        viewModel.$noUsersState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noUsers in
                if noUsers {
                    self?.usersCollectionView.backgroundView = self?.emptyStateView
                } else {
                    self?.usersCollectionView.backgroundView = nil
                }
            }
            .store(in: &subscriptions)

        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] usersList in
                self?.updateData(on: usersList)
            }
            .store(in: &subscriptions)

    }

    private func configureNavigationBar() {
        self.title = viewModel.username
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

    private func updateData(on users: [User]) {
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
        viewModel.loadMoreUsers(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user: User = viewModel.users[indexPath.item]
        self.showUserInfo?(user.login)
    }
}

// MARK: User info screen delegate

extension GFUserListViewController: UserInfoVCDelegate {
    func didRequestUsers(for username: String) {
        viewModel.username = username
        viewModel.isFollwersList = true
        title = "Followers List"
        viewModel.page = 1
        viewModel.hasMoreUsers = true
        viewModel.users.removeAll()
        usersCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        viewModel.fetchFollowers(username: username, page: viewModel.page)
    }
}
