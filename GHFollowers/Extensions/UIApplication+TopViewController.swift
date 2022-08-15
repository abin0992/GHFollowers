//
//  UIApplication+TopViewController.swift
//  GHFollowers
//
//  Created by Abin Baby on 15.08.22.
//

import UIKit

public extension UIApplication {
    static func getTopViewController(
        controller: UIViewController? = UIApplication.shared.windows.first {
            $0.isKeyWindow
        }?.rootViewController
    ) -> UIViewController? {
        if let nav: UINavigationController = controller as? UINavigationController {
            return getTopViewController(controller: nav.visibleViewController)

        } else if
            let tab: UITabBarController = controller as? UITabBarController,
            let selected: UIViewController = tab.selectedViewController
        {
            return getTopViewController(controller: selected)

        } else if let presented: UIViewController = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        return controller
    }
}
