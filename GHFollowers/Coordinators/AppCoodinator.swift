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

    private func showSearchResults(_ username: String, isModalPresentation: Bool = false) {
        let userListViewController: GFUserListViewController = GFUserListViewController.instantiate()
        userListViewController.viewModel.username = username
        userListViewController.showUserInfo = { [weak self] username in
            self?.showUserInfo(for: username, on: userListViewController)
        }
        if isModalPresentation {
            let presentingNav: BaseNavigationControllerWithCloseButton =
            BaseNavigationControllerWithCloseButton(rootViewController: userListViewController)
            presentingViewController?.present(presentingNav, animated: true)
        } else {
            presentingViewController = userListViewController
            navigationController.pushViewController(userListViewController, animated: true)
        }
    }

    private func showUserInfo(for username: String, on userList: GFUserListViewController) {
        let userInfoViewController: GFUserInfoViewController = GFUserInfoViewController.instantiate()
        userInfoViewController.username = username
        userInfoViewController.delegate = userList
        userInfoViewController.viewModel.username = username
        userInfoViewController.showFollowers = { [weak self] username in
            self?.presentingViewController = userInfoViewController
            self?.showSearchResults(username, isModalPresentation: true)
        }
        let presentingNav: BaseNavigationControllerWithCloseButton =
        BaseNavigationControllerWithCloseButton(rootViewController: userInfoViewController)
        presentingViewController?.present(presentingNav, animated: true)
    }
}
