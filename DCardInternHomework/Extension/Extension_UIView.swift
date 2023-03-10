//
//  Extension_UIView.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import UIKit
extension UIView {
    func addSubviews(_ views:UIView...) {
        if let stackView = self as? UIStackView {
            for view in views {
                stackView.addArrangedSubview(view)
            }
        }
        else {
            for view in views {
                addSubview(view)
            }
        }
    }
 
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}

