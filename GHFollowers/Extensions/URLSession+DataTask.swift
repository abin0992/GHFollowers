//
//  URLSession+DataTask.swift
//  GHFollowers
//
//  Created by Abin Baby on 01/01/21.
//

import Foundation

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), GFError>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, response, error in
            if error != nil {
                result(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                result(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                result(.failure(.invalidData))
                return
            }

            result(.success((response, data)))
        }
    }
}
