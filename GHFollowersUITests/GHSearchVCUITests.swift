//
//  GHFollwersListTests.swift
//  GHFollowersUITests
//
//  Created by Abin Baby on 02/01/21.
//

import XCTest

class GHSearchVCUITests: XCUITestBase {

    static let username: String = "twostraws"

    // MARK: - UI Tests

    func test_FollowerListScreenIsPushed() {

        // 1. Loads search screen
        check_SearchScreen_IsShown()

        // 2. Enter username and click 'get follwers' button
        enterUserName_AndTap_GetFollwerButton()

        // 3. Check if follwer list screen is presented
        check_FollwerListScreen_IsShown()
    }

    func test_EmptyUsernameAlertIsPresented() {
        // Tap on get follwers button
        app.buttons[AccessibilityIdentifier.searchViewGetFollowersButton.rawValue].staticTexts["Get Followers"].tap()

        check_EmptyUsernameAlert_IsPresented()

        check_AlertDismissal_Pressing_OkButton()
    }

    // MARK: - Helper functions

    func check_SearchScreen_IsShown() {
        let searchView: XCUIElement = app.otherElements[AccessibilityIdentifier.searchView.rawValue]
        let searchViewIsShown: Bool = searchView.waitForExistence(timeout: 5)
        XCTAssertTrue(searchViewIsShown)
    }

    func enterUserName_AndTap_GetFollwerButton() {

        let usernameTextField: XCUIElement = app.textFields[AccessibilityIdentifier.usernameTextField.rawValue]

        usernameTextField.tap()
        usernameTextField.typeText(GHSearchVCUITests.username)

        // Tap on screen to dismiss keyboard
        app.otherElements[AccessibilityIdentifier.searchView.rawValue].tap()

        // Tap on get follwers button
        app.buttons[AccessibilityIdentifier.searchViewGetFollowersButton.rawValue].staticTexts["Get Followers"].tap()
    }

    func check_FollwerListScreen_IsShown() {
        let followerListView: XCUIElement = app.otherElements[AccessibilityIdentifier.followerListView.rawValue]
        let followerListViewIsShown: Bool = followerListView.waitForExistence(timeout: 5)
        XCTAssertTrue(followerListViewIsShown)
    }

    func check_EmptyUsernameAlert_IsPresented() {
        let alertView: XCUIElement = app.otherElements[AccessibilityIdentifier.gfAlertView.rawValue]
        let alertViewIsShown: Bool = alertView.waitForExistence(timeout: 5)
        XCTAssertTrue(alertViewIsShown)
    }

    func check_AlertDismissal_Pressing_OkButton() {
        app.buttons["Ok"].tap()
        check_SearchScreen_IsShown()
    }
}
