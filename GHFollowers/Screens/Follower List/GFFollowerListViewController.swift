//
//  GFFollowerListViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFFollowerListViewController: UIViewController {

    @IBOutlet weak var followersCollectionView: UICollectionView!
    @IBOutlet weak var addToFavoritesBarButtonItem: UIBarButtonItem!

    var username: String!
    var followers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    var isLoadingMoreFollowers: Bool = false
    private lazy var dataSource: DataSource = makeDataSource()
    var emptyStateView: UIView?
    let displayUserInfoSegueIdentifier: String = "showUserInfoSegue"

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Follower>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Follower>

    enum Section { case main }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let mainStoryboard: UIStoryboard = storyboard {
            emptyStateView = mainStoryboard.instantiateViewController(withIdentifier: GFEmptyStateViewController.className).view
        }
        configureCollectionView()
        getFollowers(username: username, page: page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        self.title = username
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        followersCollectionView.delegate = self
        followersCollectionView.backgroundColor = .systemBackground
        followersCollectionView.collectionViewLayout = createThreeColumnFlowLayout()
    }

    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
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

    func makeDataSource() -> DataSource {
        let dataSource: DataSource = DataSource(collectionView: followersCollectionView) { collectionView, indexPath, follower ->
          UICollectionViewCell? in
        let cell: GFFollowerCell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerCell.reuseID, for: indexPath) as? GFFollowerCell ?? GFFollowerCell()
        cell.set(follower: follower)
        return cell
        }
      return dataSource
    }

    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true

        GFNetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {
                return
            }
            self.dismissLoadingView()

            switch result {
            case .success(let followers):
                self.updateUI(with: followers)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.description, buttonTitle: "Ok")
            }

            self.isLoadingMoreFollowers = false
        }
    }

    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)

        if self.followers.isEmpty {
            DispatchQueue.main.async {
                self.followersCollectionView.backgroundView = self.emptyStateView
                self.addToFavoritesBarButtonItem.isEnabled = false
            }
            return
        }

        self.updateData(on: self.followers)
    }

    func updateData(on followers: [Follower]) {
        var snapshot: NSDiffableDataSourceSnapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    @IBAction func addUserToFavoriteButtonAction(_ sender: Any) {
    }
}

extension GFFollowerListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == followers.count - 1 {
            guard hasMoreFollowers, !isLoadingMoreFollowers else {
                return
            }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let follower: Follower = followers[indexPath.item]

        if let mainStoryboard: UIStoryboard = storyboard {
            let destinationViewController: GFUserInfoViewController = mainStoryboard.instantiateViewController(identifier: GFUserInfoViewController.className) as GFUserInfoViewController
            destinationViewController.username = follower.login
            let navigationController: UINavigationController = UINavigationController(rootViewController: destinationViewController)

            self.present(navigationController, animated: true)
        }
    }
}
