//
//  Theme.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import UIKit

class Theme {
    static var fullSize = UIScreen.main.bounds.size
    static let factor = UIScreen.main.bounds.width / 720
    static let navigationBarTitleFont = UIFont(name:"Helvetica Neue", size:25)
    static let navigationBarBG = UIColor(hex:0x006aa6)
    static let navigationBtnSize = CGRect(x:0,y:0,width: 50 * factor, height: 50 * factor)
    static let labelFont = UIFont(name: "Helvetica-Light", size: 20)!
}
