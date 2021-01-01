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

    var username: String!
    var isLoading: Bool = false
    var user: User!
    weak var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        getUserInfo()
    }

    private func getUserInfo() {
        isLoading = true
        showLoadingView()
        GFNetworkManager.shared.getUserInfo(for: username) { [weak self] result in
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
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.description, buttonTitle: "Ok")
            }
        }
    }

    private func configureUIElements(with user: User) {
        tableView.beginUpdates()
        avatarImageView.downloadImage(fromURL: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "Global citizen 🌏"
        bioLabel.text = user.bio ?? "No  bio available"
        repoCountLabel.text = String(user.publicRepos)
        gistCountLabel.text = String(user.publicGists)
        followersCountLabel.text = String(user.followers)
        followingCountLabel.text = String(user.following)
        yearLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
        tableView.endUpdates()
    }

    @IBAction func dismissUserInfoViewController(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
            return
        }

        let safariVC: SFSafariViewController = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

    @IBAction func follwersButtonAction(_ sender: Any) {
        delegate.didRequestFollowers(for: user.login)
        self.dismiss(animated: true)
    }
}

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

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for username: String)
}
