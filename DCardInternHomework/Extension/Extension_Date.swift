//
//  Extension_Date.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/6/20.
//

import Foundation
extension Date {
    func getOffsetDay( type:Calendar.Component , offset:Int)->Date {
        return Calendar.current.date( byAdding: type, value: offset, to:self)!
    }
}
