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

    var systemUnderTest: GFSearchViewController!
    var navigationController: UINavigationController!

    // MARK: - Setup View controller

    override func setUpWithError() throws {
        super.setUp()

        systemUnderTest = GFSearchViewController.instantiate()

        navigationController = UINavigationController(rootViewController: systemUnderTest)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navigationController

        systemUnderTest.loadViewIfNeeded()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil
        navigationController = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func test_OutletsShouldBeConnected() {
        XCTAssertNotNil(systemUnderTest.usernameTextField, "usernameTextField not found")
        XCTAssertNotNil(systemUnderTest.searchButton, "Get followers button not found")
    }

    func test_HasUsernameTextField() {
        let usernameTextFieldIsSubView: Bool = systemUnderTest.usernameTextField?.isDescendant(of: systemUnderTest.view) ?? false
        XCTAssertTrue(usernameTextFieldIsSubView)
    }

    func test_GetFollwersButtonHasAction() {
        let getFollowersButton: UIButton = systemUnderTest.searchButton

        guard let actions = getFollowersButton.actions(forTarget: systemUnderTest, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("searchButtonAction:"))
    }

    func test_Controller_ShowsAlert_ForEmptyUsername() {
        systemUnderTest.usernameTextField.text = ""
        // Tap get follwers button when TextFields have empty state
        systemUnderTest.searchButton.sendActions(for: .touchUpInside)

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
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
