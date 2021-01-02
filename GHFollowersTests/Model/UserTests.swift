//
//  UserTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import GHFollowers
import XCTest

class UserTests: XCTestCase {

    private let testUsername: String = "testLogin"
    private let testUrl: String = "www.test.com"
    private let testLocation: String = "test location"
    private let testBio: String = "test bio"
    private let testCount: Int = 99
    private let testCreatedDate: Date = Date()

    func testUserInit() {
        let user: User = User(login: testUsername,
                              avatarUrl: testUrl,
                              publicRepos: testCount,
                              publicGists: testCount,
                              htmlUrl: testUrl,
                              following: testCount,
                              followers: testCount,
                              createdAt: testCreatedDate)

        XCTAssertEqual(user.login, testUsername)
        XCTAssertEqual(user.avatarUrl, testUrl)
        XCTAssertEqual(user.publicRepos, testCount)
        XCTAssertEqual(user.publicGists, testCount)
        XCTAssertEqual(user.htmlUrl, testUrl)
        XCTAssertEqual(user.following, testCount)
        XCTAssertEqual(user.followers, testCount)
        XCTAssertEqual(user.createdAt, testCreatedDate)
    }

}
