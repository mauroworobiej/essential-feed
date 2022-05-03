//
//  UIView+Extensions.swift
//  Prototype
//
//  Created by Mauro Worobiej on 02/05/2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {addSubview($0)}
    }
}
