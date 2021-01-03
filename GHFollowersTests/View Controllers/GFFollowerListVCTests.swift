//
//  GFFollowerListVCTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import GHFollowers
import XCTest

class GFFollowerListVCTests: XCTestCase {

    // MARK: - Subject under test

    var systemUnderTest: GFFollowerListViewController!
    let mockNetworkService: MockNetworkService = MockNetworkService()
    let testUsername: String = "testUsername"

    // MARK: - Setup View controller

    override func setUpWithError() throws {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard
          .instantiateViewController(
            withIdentifier: GFFollowerListViewController.className) as? GFFollowerListViewController

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
        XCTAssertNotNil(systemUnderTest.followersCollectionView, "GFFollowerListViewController should have a collection view")
    }

    func test_Controller_ShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(systemUnderTest.followersCollectionView.delegate)
    }

    func test_Controller_ConformsToCollectionViewDelegate() {
        XCTAssertTrue(systemUnderTest.responds(to: (#selector(systemUnderTest.collectionView(_:willDisplay:forItemAt:)))))
        XCTAssertTrue(systemUnderTest.responds(to: (#selector(systemUnderTest.collectionView(_:didSelectItemAt:)))))
    }

    func test_Controller_HasDataSourceForCollectionView() {
        XCTAssertNotNil(systemUnderTest.dataSource)
    }

    func test_Controller_ConformsToCollectionViewDelegateFlowLayout () {
        XCTAssertNotNil(systemUnderTest.followersCollectionView.collectionViewLayout)
    }

    func test_NumberOfItemsInSection() {
        systemUnderTest.followers.removeAll()
        systemUnderTest.loadViewIfNeeded()

        let followersCount: Int = systemUnderTest.followers.count

        XCTAssertEqual(1, systemUnderTest.followersCollectionView.numberOfSections)
        XCTAssertEqual(followersCount, systemUnderTest.followersCollectionView.numberOfItems(inSection: 0))
    }

    func test_Controller_createsCellsWith_ReuseIdentifier() {
        systemUnderTest.followers.removeAll()
        systemUnderTest.loadViewIfNeeded()

        let indexPath: IndexPath = IndexPath(item: 0, section: 0)

        systemUnderTest.fetchFollowers(username: testUsername, page: 1) {
            guard let cell: GFFollowerCell = self.systemUnderTest.followersCollectionView.dataSource?.collectionView(self.systemUnderTest.followersCollectionView, cellForItemAt: indexPath) as? GFFollowerCell else {
                XCTFail("Returning collection view cell failed")
                return
            }

            let follower: User = self.systemUnderTest.followers[indexPath.section]
            XCTAssertEqual(cell.usernameLabel.text, follower.login)

            let expectedReuseIdentifier: String = self.systemUnderTest.reuseIdentifier
            XCTAssertTrue(cell.reuseIdentifier == expectedReuseIdentifier)
        }
    }

    func test_noFollowersStateIsVisible() {
        systemUnderTest.networkService = MockEmptyFollwersService()

        systemUnderTest.loadViewIfNeeded()
        XCTAssertNotNil(systemUnderTest.emptyStateView)

        systemUnderTest.fetchFollowers(username: testUsername, page: 1) {
            XCTAssertEqual(self.systemUnderTest.followersCollectionView.backgroundView, self.systemUnderTest.emptyStateView)
        }
    }
}
