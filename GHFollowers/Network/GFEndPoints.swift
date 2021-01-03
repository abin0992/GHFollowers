//
//  GFEndPoints.swift
//  GHFollowers
//
//  Created by Abin Baby on 01/01/21.
//

import Foundation

struct GFEndpoint {
    let path: String
    var queryItems: [URLQueryItem]?
    var url: URL? {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseUrl
        components.path = path
        components.queryItems = queryItems

        return components.url
    }

    static func users(queryItems: [URLQueryItem]) -> GFEndpoint {
        GFEndpoint(
            path: "/search/users", queryItems: queryItems
        )
    }

    static func userInfo(for username: String) -> GFEndpoint {
        GFEndpoint(
            path: "/users/\(username)", queryItems: nil
        )
    }
}
