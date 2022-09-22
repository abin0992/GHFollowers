//
//  BaseNavigationControllerWithDoneButton.swift
//  GHFollowers
//
//  Created by Abin Baby on 22.09.22.
//

import UIKit

class BaseNavigationControllerWithCloseButton: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let rootVC: UIViewController = self.viewControllers.first {
            self.addDoneButton(rootVC: rootVC)
        }

        view.layoutIfNeeded()
        view.updateConstraintsIfNeeded()
    }

    private func addDoneButton(rootVC: UIViewController) {
        let doneButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        doneButton.tintColor = UIColor.systemGreen
        doneButton.accessibilityIdentifier = AccessibilityIdentifier.userInfoDoneButton.rawValue
        rootVC.navigationItem.rightBarButtonItem = doneButton
    }

    @objc
    func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
