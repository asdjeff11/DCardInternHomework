//
//  Extension_ViewController.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
extension UIViewController {
    func setUpNav(title:String,backButtonVisit:Bool = false, rightButton:UIButton? = nil, homeButtonRemove:Bool = false ) {
        if ( self.title == title ) { return }
        self.title = title
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = Theme.navigationBarBG
            navigationBarAppearance.titleTextAttributes = [
               .foregroundColor: UIColor.white,
               .font: Theme.navigationBarTitleFont ?? UIFont()
            ]
           
            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.scrollEdgeAppearance = navigationBarAppearance
            navigationItem.standardAppearance = navigationBarAppearance
            navigationItem.compactAppearance = navigationBarAppearance
            navigationController?.setNeedsStatusBarAppearanceUpdate()
        }
        else {
            self.navigationController?.navigationBar.barTintColor = Theme.navigationBarBG
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: Theme.navigationBarTitleFont ?? UIFont()
            ]
        }
        
        let homeButton = UIButton(frame: Theme.navigationBtnSize)
        var img = UIImage.scaleImage(image: UIImage(named: "home")!, newSize: Theme.navigationBtnSize.size).withRenderingMode(.alwaysTemplate)
        homeButton.tintColor = .white
        homeButton.setImage(img, for: .normal)
        homeButton.addTarget(self, action: #selector(home), for: .touchUpInside)
        
        let backButton = UIButton(frame: Theme.navigationBtnSize)
        img = UIImage.scaleImage(image: UIImage(named: "back")!, newSize: Theme.navigationBtnSize.size).withRenderingMode(.alwaysTemplate)
        //img.withTintColor(.white)
        backButton.tintColor = .white
        backButton.setImage(img, for: .normal)
        backButton.addTarget(self, action: #selector(leftBtnAct), for: .touchUpInside)
       
        
        var array:[UIBarButtonItem] = []
        
        if ( backButtonVisit == true ) {
            array.append(UIBarButtonItem(customView: backButton))
        }
       
        if ( homeButtonRemove == false ) {
            array.append(UIBarButtonItem(customView: homeButton))
        }
        
        self.navigationItem.leftBarButtonItems = array
        
        if let rightButton = rightButton {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
    }
    
    @objc func viewWillTerminate() {
        
    }
    
    @objc func home() {
        viewWillTerminate()
        guard let vc = navigationController?.viewControllers.filter({ (vc) -> Bool in
            return vc is MainViewController
        })[0] else { return }
        navigationController?.popToViewController(vc, animated: true)
    }
    
    @objc func leftBtnAct() {
        viewWillTerminate()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loading(isLoading:inout Bool) { // 參數是給有需要的使用 不需要的 無視即可
        if( isLoading ) { return }
        spinner.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(spinner.view)
        addChild(spinner)
        spinner.didMove(toParent: self)
        isLoading = true
    }
    
    func removeLoading(isLoading:inout Bool) {
        if ( isLoading == false ) { return }
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        isLoading = false
    }
    
    func addViewToPresent(viewController: UIViewController) {
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
    }
    
    
    func showAlert(alertText: String, alertMessage: String, dissmiss: Bool = false, alertAction: UIAlertAction? = nil) {
        #if DEBUG
            let mes = alertMessage
        #else
            let mes = (alertText.hasSuffix("錯誤") || alertText == "建立失敗" || alertText == "儲存失敗" ) ? "連線錯誤" : alertMessage
        #endif
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertText, message: mes, preferredStyle: UIAlertController.Style.alert)
            if let alertAction = alertAction {
                alert.addAction(alertAction)
            }
            else {
                let closeAction = UIAlertAction(title: "確定", style: .default){ [unowned self] (_) in
                    if ( dissmiss == true ) {
                        self.dismiss(animated: true)
                    }
                }
                alert.addAction(closeAction)
            }
            
            guard let _ = self.viewIfLoaded?.window,self.presentedViewController == nil else { return }
            self.present(alert, animated: true, completion: nil)
//            print("self:\(self)")
//            print("self.presentedVC:\(String(describing: self.presentedViewController))\n")
        }
    }
    
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: ({}))
    }

    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier?) {
        if let taskID = taskID {
            UIApplication.shared.endBackgroundTask(taskID)
        }
    }
}
