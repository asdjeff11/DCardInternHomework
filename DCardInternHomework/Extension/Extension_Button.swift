//
//  Extension_Button.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit

extension UIButton {
    func createSearchBtn() {
        let size = Theme.navigationBtnSize.size
        let img =  UIImage(named: "searchPic")!.withRenderingMode(.alwaysTemplate)
        tintColor = .white
            setImage(img, for: .normal)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}
