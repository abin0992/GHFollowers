//
//  GHNetworkTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

import Foundation
@testable import GHFollowers
import XCTest

class NetworkManagerTests: XCTestCase {

    let networkMock: MockNetworkManager = MockNetworkManager.shared

    func testFetchingFollwers() {
        let follwersExpectation: XCTestExpectation = expectation(description: "follwer list")

        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: MockNetworkService.testUserListJSONFile, withExtension: "json") else {
            XCTFail("Loading file '\(MockNetworkService.testUserListJSONFile).json' failed!")
            return
        }

        networkMock.fetchData(from: jsonURL) { (result: Swift.Result<UserList, GFError>) in
            switch result {
            case .success:
                follwersExpectation.fulfill()
            case .failure:
                XCTFail()
             }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
