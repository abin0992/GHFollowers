//
//  GFUserCell.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import FeedEngine
import UIKit

class GFUserCell: UICollectionViewCell {
    @IBOutlet var avatarImageView: GFAvatarImageView!
    @IBOutlet var usernameLabel: UILabel!

    func set(user: User) {
        avatarImageView.downloadImage(fromURL: user.avatarURL)
        usernameLabel.text = user.login
    }
}
