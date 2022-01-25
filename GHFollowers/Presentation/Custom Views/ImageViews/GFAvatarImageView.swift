//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage: UIImage = #imageLiteral(resourceName: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }

    func downloadImage(fromURL url: String) {
        GFNetworkManager.sharedInstance.downloadImage(from: url) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
