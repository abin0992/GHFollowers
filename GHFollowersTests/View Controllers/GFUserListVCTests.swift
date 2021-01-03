//
//  GFFollowerListVCTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import GHFollowers
import XCTest

class GFUserListVCTests: XCTestCase {

    // MARK: - Subject under test

    var systemUnderTest: GFUserListViewController!
    let mockNetworkService: MockNetworkService = MockNetworkService()
    let testUsername: String = "testUsername"

    // MARK: - Setup View controller

    override func setUpWithError() throws {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard
          .instantiateViewController(
            withIdentifier: GFUserListViewController.className) as? GFUserListViewController

        systemUnderTest.networkService = mockNetworkService
        systemUnderTest.username = testUsername

        systemUnderTest.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil

        super.tearDown()
    }

    // MARK: - Tests

    func test_Controller_HasCollectionView() {
        XCTAssertNotNil(systemUnderTest.usersCollectionView, "GFFollowerListViewController should have a collection view")
    }

    func test_Controller_ShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(systemUnderTest.usersCollectionView.delegate)
    }

    func test_Controller_ConformsToCollectionViewDelegate() {
        XCTAssertTrue(systemUnderTest.responds(to: (#selector(systemUnderTest.collectionView(_:willDisplay:forItemAt:)))))
        XCTAssertTrue(systemUnderTest.responds(to: (#selector(systemUnderTest.collectionView(_:didSelectItemAt:)))))
    }

    func test_Controller_HasDataSourceForCollectionView() {
        XCTAssertNotNil(systemUnderTest.dataSource)
    }

    func test_Controller_ConformsToCollectionViewDelegateFlowLayout () {
        XCTAssertNotNil(systemUnderTest.usersCollectionView.collectionViewLayout)
    }

    func test_NumberOfItemsInSection() {
        systemUnderTest.users.removeAll()
        systemUnderTest.loadViewIfNeeded()

        let followersCount: Int = systemUnderTest.users.count

        XCTAssertEqual(1, systemUnderTest.usersCollectionView.numberOfSections)
        XCTAssertEqual(followersCount, systemUnderTest.usersCollectionView.numberOfItems(inSection: 0))
    }

    func test_Controller_createsCellsWith_ReuseIdentifier() {
        systemUnderTest.users.removeAll()
        systemUnderTest.loadViewIfNeeded()

        let indexPath: IndexPath = IndexPath(item: 0, section: 0)

        systemUnderTest.fetchUsers(username: testUsername, page: 1) {
            guard let cell: GFUserCell = self.systemUnderTest.usersCollectionView.dataSource?.collectionView(self.systemUnderTest.usersCollectionView, cellForItemAt: indexPath) as? GFUserCell else {
                XCTFail("Returning collection view cell failed")
                return
            }

            let follower: User = self.systemUnderTest.users[indexPath.section]
            XCTAssertEqual(cell.usernameLabel.text, follower.login)

            let expectedReuseIdentifier: String = self.systemUnderTest.reuseIdentifier
            XCTAssertTrue(cell.reuseIdentifier == expectedReuseIdentifier)
        }
    }

    func test_noFollowersStateIsVisible() {
        systemUnderTest.networkService = MockEmptyFollwersService()

        systemUnderTest.loadViewIfNeeded()
        XCTAssertNotNil(systemUnderTest.emptyStateView)

        systemUnderTest.fetchUsers(username: testUsername, page: 1) {
            XCTAssertEqual(self.systemUnderTest.usersCollectionView.backgroundView, self.systemUnderTest.emptyStateView)
        }
    }
}
