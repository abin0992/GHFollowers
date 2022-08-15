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
    var isFetchUserListSucceeded = true
    var isEmptyUserListReturned = false
    var isFetchFollowerListSucceeded = false
    var isEmptyFollowerListSucceeded = false
    let testUser = User(identifier: "test", login: "testLogin", avatarURL: "www.test.com")

    func fetchUsers(_: String, page _: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
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

    func fetchFollowers(_: String, page _: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
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
