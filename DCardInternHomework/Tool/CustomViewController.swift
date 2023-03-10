//
//  CustomViewController.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
class CustomViewController:UIViewController {
    var isLoading = false
    var taskID:UIBackgroundTaskIdentifier?
    var tableView:UITableView!
    
    override func viewWillTerminate() { // 關閉頁面
        // 如果還在 loading 狀態 就返回 會發生 沒辦法將taskID end 掉 因為viewController 被釋放了 故在此告知系統 結束任務
        if ( isLoading ) {
            endBackgroundUpdateTask(taskID: taskID)
        }
    }
}


extension CustomViewController : BaseDelegate {
    @objc func startProcess(_ type: LoadingStyle) {
        taskID = beginBackgroundUpdateTask()
        switch ( type ) {
        case .spinnerLoading :
            self.loading(isLoading: &isLoading)
        default :
            return
        }
    }
    
    @objc func endProcess(_ type: LoadingStyle) {
        endBackgroundUpdateTask(taskID: taskID)
        taskID = nil
        switch ( type ) {
        case .spinnerLoading :
            self.removeLoading(isLoading: &isLoading)
        case .tableRefreshLoading :
            if self.tableView != nil {
                self.tableView.refreshControl?.endRefreshing()
            }
        default :
            return
        }
    }
    
    func showAlertFrame(_ title: String, _ subTitle: String, _ alertAction: UIAlertAction?) {
        print( subTitle ) // for debug
        self.showAlert(alertText: title, alertMessage: subTitle, alertAction:alertAction)
    }
    
    @objc func fetchCallBack() {} // for override
    
    @objc func sendCallBack() {} // for override
    
    @objc func reloadData() { // default tableView reload  if need collectionView , please override this func
        // default reload tableView
        if ( tableView != nil ) {
            DispatchQueue.main.async { [weak self] in // 保險 切回主執行緒
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
}
