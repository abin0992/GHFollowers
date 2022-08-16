//
//  AlertPresentable.swift
//  GHFollowers
//
//  Created by Abin Baby on 15.08.22.
//

import UIKit

protocol AlertPresentable {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String, presentingView: UIViewController?)
}

extension AlertPresentable where Self: UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String, presentingView: UIViewController?) {
        DispatchQueue.main.async {
            let alertVC: GFAlertViewController = GFAlertViewController(
                title: title,
                message: message,
                buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            if let presentingVc: UIViewController = presentingView {
                presentingVc.present(alertVC, animated: true)
            }
        }
    }
}
