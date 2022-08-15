//
//  Coordinator.swift
//  GHFollowers
//
//  Created by Abin Baby on 25/01/2022.
//

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate {
    // MARK: - Properties

    var didFinish: ((Coordinator) -> Void)?

    // MARK: -

    var childCoordinators: [Coordinator] = []

    // MARK: - Methods

    func start() {}

    // MARK: -

    func navigationController(_: UINavigationController, willShow _: UIViewController, animated _: Bool) {}

    func navigationController(_: UINavigationController, didShow _: UIViewController, animated _: Bool) {}

    // MARK: -

    func pushCoordinator(_ coordinator: Coordinator) {
        // Install Handler
        coordinator.didFinish = { [weak self] coordinator in
            self?.popCoordinator(coordinator)
        }

        // Start Coordinator
        coordinator.start()

        // Append to Child Coordinators
        childCoordinators.append(coordinator)
    }

    func popCoordinator(_ coordinator: Coordinator) {
        // Remove Coordinator From Child Coordinators
        if let index: Int = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
