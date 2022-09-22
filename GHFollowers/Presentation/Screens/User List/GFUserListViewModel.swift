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

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var noUsersState: Bool = false
    @Published var users: [User] = []

    var username: String!
    var page: Int = 1
    var hasMoreUsers: Bool = true
    var isFollwersList: Bool = false
    let feedRepository: FeedServiceFetchable!

    init(feedRepository: FeedServiceFetchable = FeedRepository()) {
        self.feedRepository = feedRepository
    }

    func viewDidLoad() {
        fetchUsers(username: username, page: page)
    }

    // MARK: - API call

    typealias OptionalCompletionClosure = (() -> Void)?

    func fetchUsers(username: String, page: Int, completion: OptionalCompletionClosure = nil) {

        isLoading = true

        feedRepository.fetchUsers(username, page: page) { [weak self] result in
            switch result {
            case .success(let users):
                self?.updateUI(with: users)
            case .failure(let error):
                self?.errorMessage = error.description
            }
            self?.isLoading = false
        }
    }

    func fetchFollowers(username: String, page: Int, completion: OptionalCompletionClosure = nil) {
        isLoading = true

        feedRepository.fetchFollowers(username, page: page) { [weak self] result in
            switch result {
            case .success(let followers):
                self?.updateUI(with: followers)

            case .failure(let error):
                self?.errorMessage = error.description
            }
            self?.isLoading = false
        }
    }

    private func updateUI(with users: [User]) {
        if users.count < 100 { hasMoreUsers = false }
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
