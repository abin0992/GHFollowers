//
//  GFSearchVCTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 01/01/21.
//

@testable import GHFollowers
import XCTest

class GFSearchVCTests: XCTestCase {

    // MARK: - Subject under test

    var sut: GFSearchViewController!
    var navigationController: UINavigationController!

    // MARK: - Setup View controller

    override func setUpWithError() throws {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard
          .instantiateViewController(
            withIdentifier: GFSearchViewController.className) as? GFSearchViewController

        navigationController = UINavigationController(rootViewController: sut)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navigationController

        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        navigationController = nil

        super.tearDown()
    }

    // MARK: - Tests

    func test_OutletsShouldBeConnected() {
        XCTAssertNotNil(sut.usernameTextField, "usernameTextField not found")
        XCTAssertNotNil(sut.getFollowersButton, "Get followers button not found")
    }

    func test_HasUsernameTextField() {
        let usernameTextFieldIsSubView: Bool = sut.usernameTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(usernameTextFieldIsSubView)
    }

    func test_GetFollwersButtonHasAction() {
        let getFollowersButton: UIButton = sut.getFollowersButton

        guard let actions = getFollowersButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("getFollowersButtonAction:"))
    }

    func test_GetFollwersButton_WhenTapped_FollwerListIsPushed() {
        sut.usernameTextField.text = "testUser"
        sut.getFollowersButton.sendActions(for: .touchUpInside)
        RunLoop.current.run(until: Date())

        guard let _ = navigationController.topViewController as? GFFollowerListViewController else {
            XCTFail("Follower list view controller not pushed")
            return
        }
    }

    func test_Controller_ShowsAlert_ForEmptyUsername() {

        sut.usernameTextField.text = ""
            // Tap get follwers button when TextFields have empty state
        sut.getFollowersButton.sendActions(for: .touchUpInside)

        let alertExpectation: XCTestExpectation = expectation(description: "alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {

            guard let alertController: GFAlertViewController = self.navigationController.viewControllers.last?.presentedViewController as? GFAlertViewController else {
                XCTFail("GFAlertViewController was not presented")
                return
            }

            XCTAssertNotNil(alertController, "GFAlertViewController was not presented")

            let expectedAlertTitle: String = Alert.emptyUsernameTitle
            let actualAlertTitle: String = alertController.titleLabel.text ?? "Test Title"
            XCTAssertEqual(expectedAlertTitle, actualAlertTitle)

            let expectedAlertMessage: String = Alert.emptyUsernameMessage
            let actualAlertMessage: String = alertController.messageLabel.text ?? "Test Message"
            XCTAssertEqual(expectedAlertMessage, actualAlertMessage)

            let expectedActionTitle: String = Alert.okButtonLabel
            let actualActionTitle: String = alertController.actionButton.titleLabel?.text ?? "Test Botton"
            XCTAssertEqual(expectedActionTitle, actualActionTitle)

            alertExpectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        }
}
