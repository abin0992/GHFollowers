//
//  GFService.swift
//  GHFollowers
//
//  Created by Abin Baby on 01/01/21.
//

import Foundation

class GFService {

    // MARK: Follwer list API

    func fetchFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = GFEndpoint.followersList(for: username, queryItems: queryItems).url else {
            completion(.failure(.invalidUsername))
            return
        }

        GFNetworkManager.sharedInstance.fetchData(from: url) { (result: Swift.Result<[Follower], GFError>) in
            switch result {
            case .success (let dataArray):
                completion(.success(dataArray))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: User info API

    func fetchUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void) {
        guard let url = GFEndpoint.userInfo(for: username).url else {
            completion(.failure(.invalidUsername))
            return
        }

        GFNetworkManager.sharedInstance.fetchData(from: url) { (result: Swift.Result<User, GFError>) in
            switch result {
            case .success (let user):
                completion(.success(user))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }
}
