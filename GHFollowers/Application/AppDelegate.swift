//
//  AppDelegate.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit
import DTNetworkMonitor

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appCoordinator: AppCoordinator = AppCoordinator()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Configure Window
        window?.rootViewController = appCoordinator.rootViewController

        // Make Key and Visible
        window?.makeKeyAndVisible()

        // Network logging
        DTNetworkMonitorConfiguration.shared.startMonitoring()

        // Start Coordinator
        appCoordinator.start()

        // Disable animation for UI Tests
        if CommandLine.arguments.contains("--uitesting") {
            UIView.setAnimationsEnabled(false)
          }
        return true
    }
}
