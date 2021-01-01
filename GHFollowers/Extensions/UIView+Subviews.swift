//
//  UIView+Subviews.swift
//  GHFollowers
//
//  Created by Abin Baby on 28/12/20.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
