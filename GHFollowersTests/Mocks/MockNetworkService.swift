//
//  MockNetworkService.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import  GHFollowers
import XCTest

class MockNetworkService: GFService {

    static let testUserListJSONFile: String = "test_userList"
    static let testUserInfoJSONFile: String = "test_userInfo"

    override func fetchUsers(for username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: MockNetworkService.testUserListJSONFile, withExtension: "json") else {
            XCTFail("Loading file '\(MockNetworkService.testUserListJSONFile).json' failed!")
            return
        }

        MockNetworkManager.shared.fetchData(from: jsonURL) { (result: Swift.Result<UserList, GFError>) in
            switch result {
            case .success (let dataArray):
                completion(.success(dataArray.items))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    override func fetchUserInfo(for username: String, completion: @escaping (Result<UserDetail, GFError>) -> Void) {
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: MockNetworkService.testUserInfoJSONFile, withExtension: "json") else {
            XCTFail("Loading file '\(MockNetworkService.testUserInfoJSONFile).json' failed!")
            return
        }

        MockNetworkManager.shared.fetchData(from: jsonURL) { (result: Swift.Result<UserDetail, GFError>) in
            switch result {
            case .success (let user):
                completion(.success(user))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }
}
