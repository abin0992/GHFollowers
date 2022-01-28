//
//  MockFeedRepository.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 28/01/2022.
//

@testable import FeedEngine
import Foundation
@testable import GHFollowers

class MockFeedRepository: FeedServiceFetchable {

    var isFetchUserListSucceeded: Bool = false
    var isEmptyUserListReturned: Bool = false
    var isFetchFollowerListSucceeded: Bool = false
    var isEmptyFollowerListSucceeded: Bool = false
    let testUser: User = User(identifier: "test", login: "testLogin", avatarUrl: "www.test.com")

    func fetchUsers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        if isFetchUserListSucceeded {
            if isEmptyUserListReturned {
                completion(.success([]))
            } else {
                completion(.success([testUser]))
            }
        } else {
            completion(.failure(.generic))
        }
    }

    func fetchFollowers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        if isFetchFollowerListSucceeded {
            if isEmptyFollowerListSucceeded {
                completion(.success([]))
            } else {
                completion(.success([testUser]))
            }
        } else {
            completion(.failure(.generic))
        }
    }
}
