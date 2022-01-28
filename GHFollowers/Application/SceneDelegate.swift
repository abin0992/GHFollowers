//
//  SceneDelegate.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let appCoordinator: AppCoordinator = AppCoordinator()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = UIWindow(windowScene: windowScene)

        // Configure Window
        window?.rootViewController = appCoordinator.rootViewController

        // Make Key and Visible
        window?.makeKeyAndVisible()

        // Start Coordinator
        appCoordinator.start()
    }
}
