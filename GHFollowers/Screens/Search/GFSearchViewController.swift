//
//  GFSearchViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

class GFSearchViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var getFollowersButton: UIButton!

    var isUsernameEntered: Bool {
        if let username: String = usernameTextField.text {
            return !username.isEmpty
        }
        return false
    }
    let displayFollwersSegueIdentifier: String = "showFollowersSegue"

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

    // MARK: Private functions

    private func configureUI() {
        view.accessibilityIdentifier = AccessibilityIdentifier.searchView.rawValue
        usernameTextField.accessibilityIdentifier = AccessibilityIdentifier.usernameTextField.rawValue
        getFollowersButton.accessibilityIdentifier = AccessibilityIdentifier.searchViewGetFollowersButton.rawValue

        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        usernameTextField.delegate = self
    }

    private func setUpDismissKeyboardTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    private func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: Alert.emptyUsernameTitle, message: Alert.emptyUsernameMessage, buttonTitle: Alert.okButtonLabel)
            return
        }

        usernameTextField.resignFirstResponder()
        self.performSegue(withIdentifier: displayFollwersSegueIdentifier, sender: self)
    }

    @IBAction func getFollowersButtonAction(_ sender: Any) {
        pushFollowerListVC()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == displayFollwersSegueIdentifier,
           let followerList: GFFollowerListViewController = segue.destination as? GFFollowerListViewController,
           let username: String = usernameTextField.text {
            followerList.username = username
        }
    }
}

// MARK: - Text Field Delegate

extension GFSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
