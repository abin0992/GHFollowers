//
//  GFUserListViewModelTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 28/01/2022.
//

@testable import FeedEngine
@testable import GHFollowers
import XCTest

class GFUserListViewModelTests: XCTestCase {
    var sut: GFUserListViewModel!
    var mocks: MockFeedRepository!
    var testUsers: [User] = []
    let testUsername = "testUsername"

    override func setUpWithError() throws {
        mocks = MockFeedRepository()
        sut = GFUserListViewModel(feedRepository: mocks)
        sut.username = testUsername
        XCTAssertNotNil(sut)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_FetchUserListResultSucceed() {
        mocks.isFetchUserListSucceeded = true
        sut.fetchUsers(username: testUsername, page: 00) {
            XCTAssertNotNil(self.sut.users)
        }
        XCTAssertEqual(sut.users.count, 1)
    }

    func test_FetchUsersEmptyListResultSucceed() {
        mocks.isFetchUserListSucceeded = true
        mocks.isEmptyUserListReturned = true
        let expect = XCTestExpectation(description: "Fetch successfully - empty user list")
        let numberOfUsers = 0
        sut.fetchUsers(username: testUsername, page: 00) {
            expect.fulfill()
            XCTAssertNotNil(self.sut.users)
            XCTAssertEqual(self.sut.users.count, numberOfUsers)
        }
    }

    func test_FetchUsersListResultFailed() {
        mocks.isFetchUserListSucceeded = false
        sut.fetchUsers(username: testUsername, page: 00) {
            XCTAssertNotNil(self.sut.errorMessage)
        }
    }
}
