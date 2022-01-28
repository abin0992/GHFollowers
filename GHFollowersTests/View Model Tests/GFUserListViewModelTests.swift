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
    let testUsername: String = "testUsername"

    override func setUpWithError() throws {
        mocks = MockFeedRepository()
        sut = GFUserListViewModel(feedRepository: mocks)
        sut.username = testUsername
        XCTAssertNotNil(sut)
        sut.viewDidLoad()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_FetchUserListResultSucceed() {
        mocks.isFetchUserListSucceeded = true
        let expect: XCTestExpectation = XCTestExpectation(description: "Fetch successfully - user list")
        sut.fetchUsers(username: testUsername, page: 00) {
            expect.fulfill()
            XCTAssertNotNil(self.sut.users)
        }
        wait(for: [expect], timeout: 0.1)
        XCTAssertEqual(self.sut.users.count, 1)
    }

    func test_FetchUsersEmptyListResultSucceed() {
        mocks.isFetchUserListSucceeded = true
        mocks.isEmptyUserListReturned = true
        let expect: XCTestExpectation = XCTestExpectation(description: "Fetch successfully - empty user list")
        let numberOfUsers: Int = 0
        sut.fetchUsers(username: testUsername, page: 00) {
            expect.fulfill()
            XCTAssertNotNil(self.sut.users)
            XCTAssertEqual(self.sut.users.count, numberOfUsers)
        }
    }

    func test_FetchUsersListResultFailed() {
        mocks.isFetchUserListSucceeded = false
        let expect: XCTestExpectation = XCTestExpectation(description: "Fetch user list - error return")
        sut.fetchUsers(username: testUsername, page: 00) {
            expect.fulfill()
            XCTAssertNotNil(self.sut.errorMessage)
        }
        wait(for: [expect], timeout: 0.1)
    }

}
