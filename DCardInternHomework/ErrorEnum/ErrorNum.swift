//
//  ErrorNum.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
enum URLConnectError:Error {
    case invalidUrl
    case requestFailed(Error)
    case invalidData
    case invalidResponse
}
