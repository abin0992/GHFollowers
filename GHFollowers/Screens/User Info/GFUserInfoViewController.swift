//
//  GFUserInfoViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import SafariServices
import UIKit

class GFUserInfoViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: GFAvatarImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    @IBOutlet weak var gistCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var getFollowersButton: GFButton!
    @IBOutlet weak var githubProfileButton: GFButton!

    var username: String!
    var isLoading: Bool = false
    var user: User!
    weak var delegate: UserInfoVCDelegate!
    var networkService: GFService = GFService()
    var loadingView: UIView = UIView()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = AccessibilityIdentifier.userInfoView.rawValue
        getFollowersButton.accessibilityIdentifier = AccessibilityIdentifier.userInfoGetFollowersButton.rawValue
        githubProfileButton.accessibilityIdentifier = AccessibilityIdentifier.userInfoGithubProfileButton.rawValue

        configureTableView()
        getUserInfo()
    }

    // MARK: - API call

    typealias OptionalCompletionClosure = (() -> Void)?

    func getUserInfo(completion: OptionalCompletionClosure = nil) {
        isLoading = true
        tableView.backgroundView = loadingView
        networkService.fetchUserInfo(for: username) { [weak self] result in
            guard let self = self else {
                return
            }
            self.isLoading = false
            self.dismissLoadingView()

            switch result {
            case .success(let user):
                self.user = user
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: Alert.unknownErrorTitle, message: error.description, buttonTitle: Alert.okButtonLabel)
            }
        }
    }

    // MARK: - Private functions

    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        loadingView = self.loadingView()
    }

    func configureUIElements(with user: User) {
        tableView.beginUpdates()
        avatarImageView.downloadImage(fromURL: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "Global citizen 🌏"
        bioLabel.text = user.bio ?? "No bio available"
        repoCountLabel.text = String(user.publicRepos)
        gistCountLabel.text = String(user.publicGists)
        followersCountLabel.text = String(user.followers)
        followingCountLabel.text = String(user.following)
        yearLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
        tableView.endUpdates()
    }

    private func dismissLoadingView() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = nil
        }
    }

    // MARK: - Button Actions

    @IBAction func dismissUserInfoViewController(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: Alert.invalidUrlTitle, message: Alert.invalidUrlMessage, buttonTitle: Alert.okButtonLabel)
            return
        }

        presentSafariVC(with: url)
    }

    @IBAction func follwersButtonAction(_ sender: Any) {
        delegate.didRequestFollowers(for: user.login)
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview row height

extension GFUserInfoViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading {
            return 0
        } else {
        return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Custom Protocol
protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for username: String)
}
