//
//  BaseProtocol.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
@objc enum LoadingStyle:Int {
    case noLoading
    case spinnerLoading
    case tableRefreshLoading
}

protocol BaseDelegate : AnyObject{
    func startProcess(_ type:LoadingStyle)
    func endProcess(_ type:LoadingStyle)
    func showAlertFrame(_ title:String,_ subTitle:String,_ alertAction:UIAlertAction?)
    func reloadData()
    func fetchCallBack()
    func sendCallBack()
}
