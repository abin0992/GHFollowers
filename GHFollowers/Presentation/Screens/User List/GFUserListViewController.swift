//
//  GFUserListViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import Combine
import FeedEngine
import UIKit

// MARK: - GFUserListViewController

class GFUserListViewController: UIViewController, Storyboardable, AlertPresentable, Loadable {
    @IBOutlet var usersCollectionView: UICollectionView!

    var emptyStateView: UIView?
    let displayUserInfoSegueIdentifier = "showUserInfoSegue"
    let reuseIdentifier = "userCell"
    lazy var dataSource: DataSource = makeDataSource()

    lazy var viewModel: GFUserListViewModel = {
        let viewModel = GFUserListViewModel()
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
                    self?.presentGFAlertOnMainThread(
                        title: Alert.errorTitle,
                        message: message,
                        buttonTitle: Alert.okButtonLabel,
                        presentingView: self
                    )
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
        title = viewModel.username
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        usersCollectionView.delegate = self
        usersCollectionView.backgroundColor = .systemBackground
        usersCollectionView.collectionViewLayout = createThreeColumnFlowLayout()
    }

    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width: CGFloat = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth: CGFloat = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth: CGFloat = availableWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: usersCollectionView) { collectionView, indexPath, user -> UICollectionViewCell? in
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

// MARK: UICollectionViewDelegate

extension GFUserListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.accessibilityIdentifier = AccessibilityIdentifier.userCell.rawValue
        viewModel.loadMoreUsers(indexPath)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user: User = viewModel.users[indexPath.item]
        showUserInfo?(user.login)
    }
}

// MARK: UserInfoVCDelegate

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
