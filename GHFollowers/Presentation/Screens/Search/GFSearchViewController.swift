//
//  GFSearchViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

class GFSearchViewController: UIViewController, Storyboardable, AlertPresentable {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: GFButton!

    var searchUser: ((String) -> Void)?

    var isUsernameEntered: Bool {
        if let username: String = usernameTextField.text {
            return !username.isEmpty
        }
        return false
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setUpDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        pushUserListVC()
    }
}

// MARK: - Text Field Delegate

extension GFSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushUserListVC()
        return true
    }
}

// MARK: Private functions

private extension GFSearchViewController {

    private func configureUI() {
        view.accessibilityIdentifier = AccessibilityIdentifier.searchView.rawValue
        usernameTextField.accessibilityIdentifier = AccessibilityIdentifier.usernameTextField.rawValue
        searchButton.accessibilityIdentifier = AccessibilityIdentifier.searchButton.rawValue

        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        usernameTextField.delegate = self
    }

    private func setUpDismissKeyboardTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    private func pushUserListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: Alert.emptyUsernameTitle, message: Alert.emptyUsernameMessage, buttonTitle: Alert.okButtonLabel, presentingView: self)
            return
        }

        usernameTextField.resignFirstResponder()
        if let username: String = usernameTextField.text {
            self.searchUser?(username)
        }
    }
}
