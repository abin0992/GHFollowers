//
//  FeedRepository.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/01/2022.
//

import FeedEngine
import Foundation

// MARK: - FeedServiceFetchable

protocol FeedServiceFetchable {
    func fetchUsers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void)
    func fetchFollowers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void)
}

// MARK: - FeedRepository

class FeedRepository: FeedServiceFetchable {
    // TODO: The local database fetching should go in here class

    private let feedService = GFService()

    func fetchUsers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        feedService.fetchUsers(for: username, page: page) { result in
            switch result {
            case let .success(users):
                completion(.success(users))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchFollowers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        feedService.fetchFollowers(for: username, page: page) { result in
            switch result {
            case let .success(followers):
                completion(.success(followers))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
