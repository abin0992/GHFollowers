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
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }

    static func followersList(for username: String, queryItems: [URLQueryItem]) -> GFEndpoint {
        GFEndpoint(
            path: "/users/\(username)/followers", queryItems: queryItems
        )
    }

    static func userInfo(for username: String) -> GFEndpoint {
        GFEndpoint(
            path: "/users/\(username)", queryItems: nil
        )
    }
}
