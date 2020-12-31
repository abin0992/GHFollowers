//
//  GFUserInfoViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFUserInfoViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: GFAvatarImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    var username: String!
    var placeholderUser: User = User(login: "", avatarUrl: "", name: "", location: "", bio: "", publicRepos: 0, publicGists: 0, htmlUrl: "", following: 0, followers: 0, createdAt: Date())

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        self.configureUIElements(with: placeholderUser)
        getUserInfo()
    }

    private func getUserInfo() {
        showLoadingView()
        GFNetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {
                return
            }
            self.dismissLoadingView()

            switch result {
            case .success(let user):
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
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "Global citizen 🌏"
        bioLabel.text = user.bio ?? "No  bio available"
        tableView.endUpdates()
        //self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }

    @IBAction func dismissUserInfoViewController(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GFUserInfoViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
