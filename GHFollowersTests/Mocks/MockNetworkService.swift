//
//  MockNetworkService.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import  GHFollowers
import XCTest

class MockNetworkService: GFService {

    let testFollowerListJSONFile: String = "test_followerList"

    override func fetchFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: testFollowerListJSONFile, withExtension: "json") else {
            XCTFail("Loading file '\(testFollowerListJSONFile).json' failed!")
            return
        }

        do {
            let data: Data = try Data(contentsOf: jsonURL)

            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

            let result: [Follower] = try decoder.decode([Follower].self, from: data)

            completion(.success(result))

        } catch {
            XCTFail("Reading contents of file '\(testFollowerListJSONFile).json' failed! (Exception: \(error))")
            completion(.failure(.invalidData))
        }
    }
}
