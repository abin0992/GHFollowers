//
//  AppDelegate.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Disable animation for UI Tests
        if CommandLine.arguments.contains("--uitesting") {
            UIView.setAnimationsEnabled(false)
          }
        return true
    }
}
