//
//  GFNetworkManager.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit

class GFNetworkManager {

    static let sharedInstance: GFNetworkManager = GFNetworkManager()
    let cache: NSCache = NSCache<NSString, UIImage>()
    var decoder: JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private init() {}

    // MARK: - URLSession Data task

    func fetchData <T: Decodable>(from url: URL, completion: @escaping (Result<T, GFError>) -> Void) {

        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { result in
            switch result {
            case .success(( _, let data)):
                do {
                    let result: T = try self.decoder.decode(T.self, from: data)

                    completion(.success(result))
                } catch {
                    if let error: GFError = error as? GFError {
                        return completion(.failure(error))
                    }

                    completion(.failure(.invalidData))
                }
            case .failure(let exception):
                completion(.failure(exception))
             }
        }

        task.resume()
    }

    // MARK: - Fetch image from URL or from local cache

    func downloadImage(from urlString: String, completetion: @escaping (UIImage?) -> Void) {
        let cacheKey: NSString = NSString(string: urlString)

        if let image: UIImage = cache.object(forKey: cacheKey) {
            completetion(image)
            return
        }

        guard let url: URL = URL(string: urlString) else {
            completetion(nil)
            return
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completetion(nil)
                    return
                }

            self.cache.setObject(image, forKey: cacheKey)
            completetion(image)
        }

        task.resume()
    }
}
