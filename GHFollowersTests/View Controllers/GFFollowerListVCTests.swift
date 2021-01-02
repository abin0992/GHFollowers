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

    var sut: GFFollowerListViewController!
    let mockNetworkService: MockNetworkService = MockNetworkService()
    let testUsername: String = "testUsername"

    // MARK: - Setup View controller

    override func setUpWithError() throws {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard
          .instantiateViewController(
            withIdentifier: GFFollowerListViewController.className) as? GFFollowerListViewController

        sut.networkService = mockNetworkService
        sut.username = testUsername

        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil

        super.tearDown()
    }

    // MARK: - Tests

    func test_Controller_HasCollectionView() {
        XCTAssertNotNil(sut.followersCollectionView, "GFFollowerListViewController should have a collection view")
    }

    func test_CollectionView_HasLoadingView() {
        let loadingView: UIView = sut.loadingView
        XCTAssertNotNil(loadingView)
    }

    func test_IsLoadingViewVisible() {
        XCTAssertEqual(sut.followersCollectionView.backgroundView, sut.loadingView)
    }

    func test_Controller_ShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(sut.followersCollectionView.delegate)
    }

    func test_Controller_ConformsToCollectionViewDelegate() {
        XCTAssertTrue(sut.responds(to: (#selector(sut.collectionView(_:willDisplay:forItemAt:)))))
        XCTAssertTrue(sut.responds(to: (#selector(sut.collectionView(_:didSelectItemAt:)))))
    }

    func test_Controller_HasDataSourceForCollectionView() {
        XCTAssertNotNil(sut.dataSource)
    }

    func test_Controller_ConformsToCollectionViewDelegateFlowLayout () {
        XCTAssertNotNil(sut.followersCollectionView.collectionViewLayout)
    }

    func test_NumberOfItemsInSection() {
        sut.followers.removeAll()
        sut.loadViewIfNeeded()

        let followersCount: Int = sut.followers.count

        XCTAssertEqual(1, sut.followersCollectionView.numberOfSections)
        XCTAssertEqual(followersCount, sut.followersCollectionView.numberOfItems(inSection: 0))
    }

    func test_Controller_createsCellsWith_ReuseIdentifier() {
        sut.followers.removeAll()
        sut.loadViewIfNeeded()

        let indexPath: IndexPath = IndexPath(item: 0, section: 0)

        sut.fetchFollowers(username: testUsername, page: 1) {
            guard let cell: GFFollowerCell = self.sut.followersCollectionView.dataSource?.collectionView(self.sut.followersCollectionView, cellForItemAt: indexPath) as? GFFollowerCell else {
                XCTFail("Returning collection view cell failed")
                return
            }

            let follower: Follower = self.sut.followers[indexPath.section]
            XCTAssertEqual(cell.usernameLabel.text, follower.login)

            let expectedReuseIdentifier: String = self.sut.reuseIdentifier
            XCTAssertTrue(cell.reuseIdentifier == expectedReuseIdentifier)
        }
    }

    func test_noFollowersStateIsVisible() {
        sut.networkService = MockEmptyFollwersService()

        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.emptyStateView)

        sut.fetchFollowers(username: testUsername, page: 1) {
            XCTAssertEqual(self.sut.followersCollectionView.backgroundView, self.sut.emptyStateView)
        }
    }
}
