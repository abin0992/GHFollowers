//
//  GFUserInfoVCUITests.swift
//  GHFollowersUITests
//
//  Created by Abin Baby on 03/01/21.
//

import XCTest

class GFUserInfoVCUITests: XCUITestBase {

    // MARK: - UI Tests

    func test_NavigationToGithubProfile() {
        navigateToUserInfoScreen()
        app.buttons[AccessibilityIdentifier.userInfoGithubProfileButton.rawValue].staticTexts["Github Profile"].tap()
        let urlElement: XCUIElement = app/*@START_MENU_TOKEN@*/.otherElements["URL"]/*[[".otherElements[\"BrowserView?WebViewProcessID=24160\"]",".otherElements[\"TopBrowserBar\"]",".buttons[\"Address\"]",".otherElements[\"Address\"]",".otherElements[\"URL\"]",".buttons[\"URL\"]"],[[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2],[-1,0,1]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3]],[[-1,4],[-1,3]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertNotNil(urlElement)
    }

    func test_NavigationToFollowersList() {
        navigateToUserInfoScreen()
        app.buttons[AccessibilityIdentifier.userInfoGetFollowersButton.rawValue].staticTexts["Get Followers"].tap()
        check_FollowerListScreenIsVisible()
    }

    func test_DismissUserInfoSCreen() {
        navigateToUserInfoScreen()
        app.navigationBars.buttons[AccessibilityIdentifier.userInfoDoneButton.rawValue].tap()
        check_FollowerListScreenIsVisible()
    }

    // MARK: - Helper

    func check_FollowerListScreenIsVisible() {
        let followerListView: XCUIElement = app.otherElements[AccessibilityIdentifier.followerListView.rawValue]
        let followerListViewIsShown: Bool = followerListView.waitForExistence(timeout: 5)
        XCTAssertTrue(followerListViewIsShown)
    }

    func navigateToUserInfoScreen() {
        let usernameTextField: XCUIElement = app.textFields[AccessibilityIdentifier.usernameTextField.rawValue]

        usernameTextField.tap()
        usernameTextField.typeText(GHSearchVCUITests.username)

        // Tap on screen to dismiss keyboard
        app.otherElements[AccessibilityIdentifier.searchView.rawValue].tap()

        // Tap on get follwers button
        app.buttons[AccessibilityIdentifier.searchViewGetFollowersButton.rawValue].staticTexts["Get Followers"].tap()

        let followerListView: XCUIElement = app.otherElements[AccessibilityIdentifier.followerListView.rawValue]
        let followerListViewIsShown: Bool = followerListView.waitForExistence(timeout: 5)
        XCTAssertTrue(followerListViewIsShown)

        // Tap on a follower item
        let followerListCollectionView: XCUIElement = app.collectionViews[AccessibilityIdentifier.followerListCollectionView.rawValue]
        followerListCollectionView.cells.element(boundBy: 0).tap()

        let userInfoView: XCUIElementQuery =
            app.tables.matching(identifier: AccessibilityIdentifier.userInfoView.rawValue)

        XCTAssertNotNil(userInfoView)
    }
}
