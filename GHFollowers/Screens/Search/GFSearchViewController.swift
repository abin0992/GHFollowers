//
//  GFSearchViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

class GFSearchViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var getFollowersButton: UIButton!

    var isUsernameEntered: Bool {
        if let username: String = usernameTextField.text {
            return !username.isEmpty
        }
        return false
    }
    let displayFollwersSegueIdentifier: String = "showFollowersSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureUI() {
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        usernameTextField.delegate = self
    }

    private func createDismissKeyboardTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func getFollowersButtonAction(_ sender: Any) {
        pushFollowerListVC()
    }

    func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "Ok")
            return
        }

        usernameTextField.resignFirstResponder()
        self.performSegue(withIdentifier: displayFollwersSegueIdentifier, sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == displayFollwersSegueIdentifier,
           let followerList: GFFollowerListViewController = segue.destination as? GFFollowerListViewController,
           let username: String = usernameTextField.text {
            followerList.username = username
        }
    }
}

extension GFSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
