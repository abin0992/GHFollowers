//
//  FeedRepository.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/01/2022.
//

import FeedEngine
import Foundation

protocol FeedServiceFetchable {
    func fetchUsers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void)
    func fetchFollowers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void)
}

class FeedRepository: FeedServiceFetchable {
    // TODO: The local database fetching should go in here class

    private let feedService: GFService = GFService()

    func fetchUsers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        feedService.fetchUsers(for: username, page: page) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchFollowers(_ username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        feedService.fetchFollowers(for: username, page: page) { result in
            switch result {
            case .success(let followers):
                completion(.success(followers))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
