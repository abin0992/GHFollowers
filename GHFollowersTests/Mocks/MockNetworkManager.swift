//
//  MockNetworkManager.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

import Foundation
@testable import GHFollowers
import XCTest

class MockNetworkManager: GFNetworkManager {
    static let shared: MockNetworkManager = MockNetworkManager()

    override func fetchData<T>(from url: URL, completion: @escaping (Result<T, GFError>) -> Void) where T: Decodable {
        do {
            let data: Data = try Data(contentsOf: url)
            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

            let result: T = try decoder.decode(T.self, from: data)

            completion(.success(result))

        } catch {
            XCTFail("Reading contents of file '\(url).json' failed! (Exception: \(error))")
            completion(.failure(.invalidData))
        }
    }
}
