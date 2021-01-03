//
//  GFUserCell.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFUserCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: GFAvatarImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    func set(user: User) {
        avatarImageView.downloadImage(fromURL: user.avatarUrl)
        usernameLabel.text = user.login
    }

}
