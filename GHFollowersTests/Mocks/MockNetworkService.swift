//
//  MockNetworkService.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import  GHFollowers
import XCTest

class MockNetworkService: GFService {

    static let testFollowerListJSONFile: String = "test_followerList"
    static let testUserInfoJSONFile: String = "test_userInfo"

    override func fetchFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: MockNetworkService.testFollowerListJSONFile, withExtension: "json") else {
            XCTFail("Loading file '\(MockNetworkService.testFollowerListJSONFile).json' failed!")
            return
        }

        MockNetworkManager.shared.fetchData(from: jsonURL) { (result: Swift.Result<[Follower], GFError>) in
            switch result {
            case .success (let dataArray):
                completion(.success(dataArray))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    override func fetchUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void) {
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: MockNetworkService.testUserInfoJSONFile, withExtension: "json") else {
            XCTFail("Loading file '\(MockNetworkService.testFollowerListJSONFile).json' failed!")
            return
        }

        MockNetworkManager.shared.fetchData(from: jsonURL) { (result: Swift.Result<User, GFError>) in
            switch result {
            case .success (let user):
                completion(.success(user))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }
}
