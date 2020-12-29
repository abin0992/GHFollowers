//
//  UIViewController+ClassName.swift
//  GHFollowers
//
//  Created by Abin Baby on 29/12/20.
//

import UIKit
extension UIViewController {
    static var className: String {
        String(describing: self)
    }
}
