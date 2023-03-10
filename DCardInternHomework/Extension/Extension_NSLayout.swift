//
//  Extension_NSLayout.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import UIKit

extension NSLayoutConstraint {
    public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                 view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}
