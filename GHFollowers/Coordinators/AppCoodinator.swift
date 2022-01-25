//
//  AppCoodinator.swift
//  GHFollowers
//
//  Created by Abin Baby on 25/01/2022.
//

import UIKit

class AppCoordinator: Coordinator {

    // MARK: - Properties

    private var navigationController: UINavigationController = UINavigationController()
    private var presentingViewController: UIViewController?

    // MARK: - Public API

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Overrides

    override func start() {
        showSearchView()
        navigationController.navigationBar.tintColor = .systemGreen
    }

    private func showSearchView() {
        let searchViewController: GFSearchViewController = GFSearchViewController.instantiate()
        searchViewController.searchUser = { [weak self] username in
            self?.showSearchResults(username)
        }
        navigationController.pushViewController(searchViewController, animated: true)
    }

    private func showSearchResults(_ username: String) {
        let userListViewController: GFUserListViewController = GFUserListViewController.instantiate()
        userListViewController.viewModel.username = username
        userListViewController.showUserInfo = { [weak self] username in
            self?.showUserInfo(for: username, on: userListViewController)
        }
        presentingViewController = userListViewController
        navigationController.pushViewController(userListViewController, animated: true)
    }

    private func showUserInfo(for username: String, on userList: GFUserListViewController) {
        let userInfoViewController: GFUserInfoViewController = GFUserInfoViewController.instantiate()
        userInfoViewController.username = username
        userInfoViewController.delegate = userList
        userInfoViewController.viewModel.username = username

        navigationController = UINavigationController(rootViewController: userInfoViewController)
        navigationController.delegate = self
        presentingViewController?.present(navigationController, animated: true)
    }
}
