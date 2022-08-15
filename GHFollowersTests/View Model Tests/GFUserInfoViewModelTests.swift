//
//  GFUserInfoViewModelTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 28/01/2022.
//

@testable import FeedEngine
@testable import GHFollowers
import XCTest

class GFUserInfoViewModelTests: XCTestCase {
    var sut: GFUserInfoViewModel!
    var mocks: MockFeedRepository!
    var testUsers: [User] = []

    override func setUpWithError() throws {
        mocks = MockFeedRepository()
        sut = GFUserInfoViewModel()
        sut.username = "test"
        XCTAssertNotNil(sut)
        sut.viewDidLoad()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

//    func testFetchUserInfoResultSucceed() {
//        sut.username = "test"
//        sut.getUserInfo {
//            XCTAssertNotNil(self.sut.user)
//        }
//    }
}
