//
//  GFService.swift
//  GHFollowers
//
//  Created by Abin Baby on 01/01/21.
//

import Foundation

class GFService {

    // MARK: User list API

    func fetchUsers(for searchKey: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "q", value: "\(searchKey)"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = GFEndpoint.users(queryItems: queryItems).url else {
            completion(.failure(.invalidUsername))
            return
        }

        GFNetworkManager.sharedInstance.fetchData(from: url) { (result: Swift.Result<UserList, GFError>) in
            switch result {
            case .success (let dataArray):
                completion(.success(dataArray.items))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: User info API

    func fetchUserInfo(for username: String, completion: @escaping (Result<UserDetail, GFError>) -> Void) {
        guard let url = GFEndpoint.userInfo(for: username).url else {
            completion(.failure(.invalidUsername))
            return
        }

        GFNetworkManager.sharedInstance.fetchData(from: url) { (result: Swift.Result<UserDetail, GFError>) in
            switch result {
            case .success (let user):
                completion(.success(user))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }
}
