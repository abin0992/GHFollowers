//
//  Storyboardable.swift
//  GHFollowers
//
//  Created by Abin Baby on 25/01/2022.
//

import UIKit

protocol Storyboardable {

    // MARK: - Properties

    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }

    // MARK: -

    static var storyboardIdentifier: String { get }

    // MARK: - Methods

    static func instantiate() -> Self

}

extension Storyboardable where Self: UIViewController {

    // MARK: - Properties

    static var storyboardName: String {
        "Main"
    }

    static var storyboardBundle: Bundle {
        .main
    }

    // MARK: -

    static var storyboardIdentifier: String {
        String(describing: self)
    }

    // MARK: - Methods

    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardName, bundle: storyboardBundle).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(storyboardIdentifier)")
        }

        return viewController
    }

}
