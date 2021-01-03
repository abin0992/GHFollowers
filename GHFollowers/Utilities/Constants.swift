//
//  Constants.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import Foundation

struct Constants {
    static let baseUrl: String = "api.github.com"
}

struct Alert {
    static let emptyUsernameTitle: String = "Empty Username"
    static let emptyUsernameMessage: String = "Please enter a username. We need to know who to look for 😀."
    static let okButtonLabel: String = "Ok"

    static let errorTitle: String = "Oops 🙁"
    static let unknownErrorTitle: String = "Something went wrong 🙁"
    static let invalidUrlTitle: String = "Invalid URL"
    static let invalidUrlMessage: String = "The url attached to this user is invalid."
}
