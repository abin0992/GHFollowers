//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import FeedEngine
import UIKit

class GFAvatarImageView: UIImageView {

    private let feedService: GFService = GFService()

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
        feedService.downloadImage(from: url) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
