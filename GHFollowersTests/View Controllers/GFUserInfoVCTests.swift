//
//  GFUserInfoVCTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import GHFollowers
import SafariServices
import XCTest

class GFUserInfoVCTests: XCTestCase {

    // MARK: - Subject under test

    var systemUnderTest: GFUserInfoViewController!
    let mockNetworkService: MockNetworkService = MockNetworkService()
    let testUsername: String = "testUsername"

    // MARK: - Setup View controller

    override func setUpWithError() throws {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard
          .instantiateViewController(
            withIdentifier: GFUserInfoViewController.className) as? GFUserInfoViewController

        systemUnderTest.networkService = mockNetworkService
        systemUnderTest.username = testUsername

        systemUnderTest.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil

        super.tearDown()
    }

    // MARK: - Tests

    func test_OutletsShouldBeConnected() {
        XCTAssertNotNil(systemUnderTest.avatarImageView, "Avatar imageview not found")
        XCTAssertNotNil(systemUnderTest.usernameLabel, "Username label not found")
        XCTAssertNotNil(systemUnderTest.nameLabel, "Name label not found")
        XCTAssertNotNil(systemUnderTest.locationLabel, "Location label not found")
        XCTAssertNotNil(systemUnderTest.bioLabel, "Bio label not found")
        XCTAssertNotNil(systemUnderTest.repoCountLabel, "Repositiory count label not found")
        XCTAssertNotNil(systemUnderTest.gistCountLabel, "Gist count label not found")
        XCTAssertNotNil(systemUnderTest.followersCountLabel, "Follwers count label not found")
        XCTAssertNotNil(systemUnderTest.followingCountLabel, "Follwing count label not found")
        XCTAssertNotNil(systemUnderTest.yearLabel, "Year label not found")
        XCTAssertNotNil(systemUnderTest.getFollowersButton, "Get followers button not found")
        XCTAssertNotNil(systemUnderTest.githubProfileButton, "Github profile button not found")
    }

    func test_ControllerHasTableView() {
        XCTAssertNotNil(systemUnderTest.tableView, "GFUserInfoViewController should have a tableview")
    }

    func test_TableViewHasDataSource() {
        XCTAssertTrue(systemUnderTest.tableView.dataSource is GFUserInfoViewController)

    }

    func test_TableViewNumberOfRows() {
        systemUnderTest.loadViewIfNeeded()
        let expectedNumberOfRows: Int = 4
        XCTAssertEqual(expectedNumberOfRows, systemUnderTest.tableView.numberOfRows(inSection: 0))
    }

    func test_ControllerFetchesUserInfo() {
        systemUnderTest.loadViewIfNeeded()

        systemUnderTest.getUserInfo {
            XCTAssertNotNil(self.systemUnderTest.user)
        }
    }

    func test_ControllerLabelsText() {
        self.systemUnderTest.configureUIElements(with: self.systemUnderTest.user)

        XCTAssertEqual(self.systemUnderTest.usernameLabel.text, self.systemUnderTest.user.login)

        XCTAssertEqual(self.systemUnderTest.nameLabel.text, self.systemUnderTest.user.name)

        XCTAssertEqual(self.systemUnderTest.locationLabel.text, self.systemUnderTest.user.location)

        XCTAssertEqual(self.systemUnderTest.bioLabel.text, self.systemUnderTest.user.bio)

        XCTAssertEqual(self.systemUnderTest.repoCountLabel.text, String(self.systemUnderTest.user.publicRepos))

        XCTAssertEqual(self.systemUnderTest.gistCountLabel.text, String(self.systemUnderTest.user.publicGists))

        XCTAssertEqual(self.systemUnderTest.followersCountLabel.text, String(self.systemUnderTest.user.followers))

        XCTAssertEqual(self.systemUnderTest.followingCountLabel.text, String(self.systemUnderTest.user.following))

        let expectedYearLabel: String = "GitHub since \(self.systemUnderTest.user.createdAt.convertToMonthYearFormat())"
        XCTAssertEqual(self.systemUnderTest.yearLabel.text, expectedYearLabel)
    }

    func test_GetFollwersButtonHasAction() {
        let getFollowersButton: UIButton = systemUnderTest.getFollowersButton

        guard let actions = getFollowersButton.actions(forTarget: systemUnderTest, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("follwersButtonAction:"))
    }

    func test_GithubProfileButton_HasAction() {
        let getFollowersButton: UIButton = systemUnderTest.githubProfileButton

        guard let actions = getFollowersButton.actions(forTarget: systemUnderTest, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("profileButtonAction:"))
    }

    func test_GighubProfileButton_WhenTapped_SFSafariVCIsPresented() {
        let navigationController: UINavigationController = UINavigationController(rootViewController: systemUnderTest)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navigationController

        systemUnderTest.loadViewIfNeeded()

        systemUnderTest.githubProfileButton.sendActions(for: .touchUpInside)
        RunLoop.current.run(until: Date())

        let safariExpectation: XCTestExpectation = expectation(description: "show SFSafariVC")

        if let _ = navigationController.viewControllers.last?.presentedViewController as? SFSafariViewController {
            safariExpectation.fulfill()
        } else {
            XCTFail("SFSafariViewController was not presented")
            return
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
