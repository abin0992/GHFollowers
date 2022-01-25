//
//  GFUserInfoViewModel.swift
//  GHFollowers
//
//  Created by Abin Baby on 25/01/2022.
//

import FeedEngine
import Foundation

class GFUserInfoViewModel {

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var user: UserDetail!
    @Published private(set) var errorMessage: String = ""

    var feedService: GFService = GFService()
    var username: String!

    func viewDidLoad() {
        getUserInfo()
    }

    // MARK: - API call

    typealias OptionalCompletionClosure = (() -> Void)?

    func getUserInfo(completion: OptionalCompletionClosure = nil) {
        isLoading = true
        feedService.fetchUserInfo(for: username) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.errorMessage = error.description
            }
        }
    }
}
