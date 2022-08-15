//
//  GFUserInfoViewModel.swift
//  GHFollowers
//
//  Created by Abin Baby on 25/01/2022.
//

import FeedEngine
import Foundation

class GFUserInfoViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var user: UserDetail!
    @Published private(set) var errorMessage = ""

    var feedService = GFService()
    var username = ""

    func viewDidLoad() {
        getUserInfo()
    }

    // MARK: - API call

    typealias OptionalCompletionClosure = (() -> Void)?

    func getUserInfo(completion _: OptionalCompletionClosure = nil) {
        isLoading = true
        feedService.fetchUserInfo(for: username) { [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(user):
                self?.user = user
            case let .failure(error):
                self?.errorMessage = error.description
            }
        }
    }
}
