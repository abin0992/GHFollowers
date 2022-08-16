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
    var mocks: MockFeedRepository!
    let mockRepository: MockFeedRepository = MockFeedRepository()
    let testUsername: String = "testUsername"

    // MARK: - Setup View controller

    override func setUpWithError() throws {

        systemUnderTest = GFUserListViewController.instantiate()
        mocks = MockFeedRepository()

        systemUnderTest.viewModel = GFUserListViewModel(feedRepository: mocks)
        systemUnderTest.viewModel.username = testUsername

        systemUnderTest.loadViewIfNeeded()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil

        try super.tearDownWithError()
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

    func test_Controller_createsCellsWith_ReuseIdentifier() {
        systemUnderTest.loadViewIfNeeded()
        systemUnderTest.viewModel.fetchUsers(username: testUsername, page: 00) {
            let indexPath: IndexPath = IndexPath(item: 0, section: 0)

            guard let cell: GFUserCell = self.systemUnderTest.usersCollectionView.dataSource?.collectionView(self.systemUnderTest.usersCollectionView, cellForItemAt: indexPath) as? GFUserCell else {
                XCTFail("Returning collection view cell failed")
                return
            }

            let expectedReuseIdentifier: String = self.systemUnderTest.reuseIdentifier
            XCTAssertTrue(cell.reuseIdentifier == expectedReuseIdentifier)
        }
    }

    func test_noFollowersStateIsVisible() {

        mocks.isEmptyFollowerListSucceeded = true
        systemUnderTest.viewModel = GFUserListViewModel(feedRepository: mocks)

        systemUnderTest.loadViewIfNeeded()
        systemUnderTest.viewModel.fetchUsers(username: testUsername, page: 00) {
            XCTAssertNotNil(self.systemUnderTest.emptyStateView)

            XCTAssertEqual(self.systemUnderTest.usersCollectionView.backgroundView, self.systemUnderTest.emptyStateView)
        }
    }
}
