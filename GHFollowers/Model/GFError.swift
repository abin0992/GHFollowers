//
//  GFError.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import Foundation

enum GFError: Error {

    case invalidUsername
    case unableToComplete
    case invalidResponse
    case invalidData
    case unableToFavorite
    case alreadyInFavorites

    var description: String {
            switch self {
            case .invalidUsername:
                return "This username created an invalid request. Please try again."
            case .unableToComplete:
                return "Unable to complete your request. Please check your internet connection"
            case .invalidResponse:
                return "Invalid response from the server. Please try again."
            case .invalidData:
                return "The data received from the server was invalid. Please try again."
            case .unableToFavorite:
                return "There was an error favoriting this user. Please try again."
            case .alreadyInFavorites:
                return "You've already favorited this user. You must REALLY like them!"
            }
        }
}
