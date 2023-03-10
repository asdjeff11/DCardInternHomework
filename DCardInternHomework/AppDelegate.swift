//
//  AppDelegate.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nav = UINavigationController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
        
        let vc = MainViewController()
        
        nav.viewControllers = [vc]
        self.window = UIWindow(frame: UIScreen.main.bounds)
      
        self.window?.rootViewController = nav // root
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = UIColor.white
        
       
        return true
    }
    
}

