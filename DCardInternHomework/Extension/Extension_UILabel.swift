//
//  Extension_UILabel.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
extension UILabel {
    static func createLabel(size:CGFloat,color:UIColor,alignment:NSTextAlignment? = nil,alpha:CGFloat? = nil,text:String = "")->UILabel {
        let label = UILabel()
        label.font = Theme.labelFont.withSize(size)
        label.textColor = color
        if ( text != "") {
            label.text = text
        }
        
        if let alignment = alignment {
            label.textAlignment = alignment
        }
        if let alpha = alpha {
            label.backgroundColor = UIColor(white:0 ,alpha: alpha)
        }
        return label
    }
}
