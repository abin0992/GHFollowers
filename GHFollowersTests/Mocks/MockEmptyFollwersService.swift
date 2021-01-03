//
//  MockEmptyFollwersService.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import  GHFollowers
import XCTest

class MockEmptyFollwersService: GFService {
    override func fetchFollowers(for username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {

        let result: [User] = []
        completion(.success(result))
    }
}
