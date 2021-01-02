//
//  UIViewController+LoadingView.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

extension UIViewController {

    func loadingView() -> UIView {
        let loadingView: UIView = UIView(frame: view.bounds)
        view.addSubview(loadingView)

        loadingView.backgroundColor = .systemBackground
        loadingView.alpha = 0

        UIView.animate(withDuration: 0.25) { loadingView.alpha = 0.8 }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        loadingView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        ])

        activityIndicator.startAnimating()
        return loadingView
    }
}
