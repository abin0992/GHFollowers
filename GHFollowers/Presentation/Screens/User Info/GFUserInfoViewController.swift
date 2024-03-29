//
//  GFUserInfoViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import Combine
import FeedEngine
import SafariServices
import UIKit

class GFUserInfoViewController: UITableViewController, Storyboardable, AlertPresentable, Loadable {

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
    lazy var viewModel: GFUserInfoViewModel = {
        let viewModel: GFUserInfoViewModel = GFUserInfoViewModel()
        return viewModel
    }()
    weak var delegate: UserInfoVCDelegate!
    private var subscriptions: Set<AnyCancellable> = []
    var showFollowers: ((String) -> Void)?

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = AccessibilityIdentifier.userInfoView.rawValue
        getFollowersButton.accessibilityIdentifier = AccessibilityIdentifier.userInfoGetFollowersButton.rawValue
        githubProfileButton.accessibilityIdentifier = AccessibilityIdentifier.userInfoGithubProfileButton.rawValue

        configureTableView()
        bindViewModel()
        viewModel.viewDidLoad()
    }

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

        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userInfo in
                if let userInfo: UserDetail = userInfo {
                    self?.configureUIElements(with: userInfo)
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
                        presentingView: self)
                }
            }
            .store(in: &subscriptions)
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        guard let url = URL(string: viewModel.user.htmlUrl) else {
            presentGFAlertOnMainThread(title: Alert.invalidUrlTitle, message: Alert.invalidUrlMessage, buttonTitle: Alert.okButtonLabel, presentingView: self)
            return
        }

        presentSafariVC(with: url)
    }

    @IBAction func follwersButtonAction(_ sender: Any) {
        delegate.didRequestUsers(for: viewModel.user.login)
        self.showFollowers?(viewModel.user.login)
    }
}

// MARK: - Tableview row height

extension GFUserInfoViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isLoading {
            return 0
        } else {
        return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Private functions

private extension GFUserInfoViewController {
    private func presentSafariVC(with url: URL) {
        let safariVC: SFSafariViewController = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func configureUIElements(with user: UserDetail) {
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
}

// MARK: - Custom Protocol
protocol UserInfoVCDelegate: AnyObject {
    func didRequestUsers(for username: String)
}
