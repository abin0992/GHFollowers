//
//  GFNetworkManager.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFNetworkManager {

    static let shared: GFNetworkManager = GFNetworkManager()
    private let baseURL: String = "https://api.github.com"
    let cache: NSCache = NSCache<NSString, UIImage>()

    private init() {}

    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = GFEndpoint.followersList(for: username, queryItems: queryItems).url else {
            completed(.failure(.invalidUsername))
            return
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, response, error in

            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers: [Follower] = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        guard let url = GFEndpoint.userInfo(for: username).url else {
            completed(.failure(.invalidUsername))
            return
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, response, error in

            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user: User = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey: NSString = NSString(string: urlString)

        if let image: UIImage = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url: URL = URL(string: urlString) else {
            completed(nil)
            return
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }

            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }

        task.resume()
    }
}
