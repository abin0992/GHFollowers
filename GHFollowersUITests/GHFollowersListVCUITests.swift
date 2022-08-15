//
//  GHFollowersListVCUITests.swift
//  GHFollowersUITests
//
//  Created by Abin Baby on 02/01/21.
//

import XCTest

class GHFollowersListVCUITests: XCUITestBase {
    // MARK: - UI Tests

    func test_FollowerListDisplaysData() {
        navigateToFollowerListScreen()
        check_FollowerList_IsLoaded_WithData()
    }

    func test_BackButtonNavigation() {
        navigateToFollowerListScreen()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        check_SearchScreen_IsShown()
    }

    func test_UserInfoScreenIsPresented() {
        navigateToFollowerListScreen()
        let followerListCollectionView: XCUIElement = app.collectionViews[AccessibilityIdentifier.userListCollectionView.rawValue]
        followerListCollectionView.cells.element(boundBy: 0).tap()
        check_UserInfoScreenIsPresented()
    }

    // MARK: - Helper

    func check_UserInfoScreenIsPresented() {
        let userInfoView: XCUIElementQuery =
            app.tables.matching(identifier: AccessibilityIdentifier.userInfoView.rawValue)

        XCTAssertNotNil(userInfoView)
    }

    func check_FollowerList_IsLoaded_WithData() {
        // Assuming the test user we used still exists
        let followerListCollectionView: XCUIElement = app.collectionViews[AccessibilityIdentifier.userListCollectionView.rawValue]
        let followerCell: XCUIElement = followerListCollectionView.cells.element(matching: .cell, identifier: AccessibilityIdentifier.userCell.rawValue)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: followerCell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func check_SearchScreen_IsShown() {
        let searchView: XCUIElement = app.otherElements[AccessibilityIdentifier.searchView.rawValue]
        let searchViewIsShown: Bool = searchView.waitForExistence(timeout: 5)
        XCTAssertTrue(searchViewIsShown)
    }

    func navigateToFollowerListScreen() {
        let usernameTextField: XCUIElement = app.textFields[AccessibilityIdentifier.usernameTextField.rawValue]

        usernameTextField.tap()
        usernameTextField.typeText(GHSearchVCUITests.username)

        // Tap on screen to dismiss keyboard
        app.otherElements[AccessibilityIdentifier.searchView.rawValue].tap()

        // Tap on get follwers button
        app.buttons[AccessibilityIdentifier.searchButton.rawValue].staticTexts["Search"].tap()

        let followerListView: XCUIElement = app.otherElements[AccessibilityIdentifier.userListView.rawValue]
        let followerListViewIsShown: Bool = followerListView.waitForExistence(timeout: 5)
        XCTAssertTrue(followerListViewIsShown)
    }
}
