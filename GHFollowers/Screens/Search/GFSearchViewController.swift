//
//  GFSearchViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

class GFSearchViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: GFButton!

    var isUsernameEntered: Bool {
        if let username: String = usernameTextField.text {
            return !username.isEmpty
        }
        return false
    }
    let displayUserListSegueIdentifier: String = "showUsersSegue"

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
            presentGFAlertOnMainThread(title: Alert.emptyUsernameTitle, message: Alert.emptyUsernameMessage, buttonTitle: Alert.okButtonLabel)
            return
        }

        usernameTextField.resignFirstResponder()
        self.performSegue(withIdentifier: displayUserListSegueIdentifier, sender: self)
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        pushUserListVC()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == displayUserListSegueIdentifier,
           let userList: GFUserListViewController = segue.destination as? GFUserListViewController,
           let username: String = usernameTextField.text {
            userList.username = username
        }
    }
}

// MARK: - Text Field Delegate

extension GFSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushUserListVC()
        return true
    }
}
