//
//  GFUserListViewModel.swift
//  GHFollowers
//
//  Created by Abin Baby on 25/01/2022.
//

import Combine
import FeedEngine
import Foundation

class GFUserListViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var noUsersState = true
    @Published var users: [User] = []

    var username: String!
    var page = 1
    var hasMoreUsers = true
    var isSearching = false
    var isFollwersList = false
    let feedRepository: FeedServiceFetchable!

    init(feedRepository: FeedServiceFetchable = FeedRepository()) {
        self.feedRepository = feedRepository
    }

    func viewDidLoad() {
        fetchUsers(username: username, page: page)
    }

    // MARK: - API call

    typealias OptionalCompletionClosure = (() -> Void)?

    func fetchUsers(username: String, page: Int, completion _: OptionalCompletionClosure = nil) {
        isLoading = true

        feedRepository.fetchUsers(username, page: page) { [weak self] result in
            switch result {
            case let .success(users):
                self?.updateUI(with: users)
            case let .failure(error):
                self?.errorMessage = error.description
            }
            self?.isLoading = false
        }
    }

    func fetchFollowers(username: String, page: Int, completion _: OptionalCompletionClosure = nil) {
        isLoading = true

        feedRepository.fetchFollowers(username, page: page) { [weak self] result in
            switch result {
            case let .success(followers):
                self?.updateUI(with: followers)

            case let .failure(error):
                self?.errorMessage = error.description
            }
            self?.isLoading = false
        }
    }

    private func updateUI(with users: [User]) {
        if users.count < 100 {
            hasMoreUsers = false
        }
        self.users.append(contentsOf: users)

        if !users.isEmpty {
            noUsersState = false
        } else {
            noUsersState = true
            return
        }
    }

    func loadMoreUsers(_ indexPath: IndexPath) {
        if indexPath.item == users.count - 1 {
            guard hasMoreUsers, !isLoading else {
                return
            }
            page += 1
            if isFollwersList {
                fetchFollowers(username: username, page: page)
            } else {
                fetchUsers(username: username, page: page)
            }
        }
    }
}
