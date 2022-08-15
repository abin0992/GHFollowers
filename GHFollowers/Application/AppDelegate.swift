//
//  AppDelegate.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let appCoordinator = AppCoordinator()
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Configure Window
        window?.rootViewController = appCoordinator.rootViewController

        // Make Key and Visible
        window?.makeKeyAndVisible()

        // Start Coordinator
        appCoordinator.start()

        // Disable animation for UI Tests
        if CommandLine.arguments.contains("--uitesting") {
            UIView.setAnimationsEnabled(false)
        }
        return true
    }
}
