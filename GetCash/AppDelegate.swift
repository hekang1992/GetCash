//
//  AppDelegate.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        getChangeRootVcNoti()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AppDelegate {
    
    private func getChangeRootVcNoti() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(changeRootVC),
                                             name: NSNotification.Name("changeRootVc"),
                                             object: nil)
    }
    
    @objc private func changeRootVC() {
        if LoginManager.isLoggedIn {
            self.window?.rootViewController = BaseTabBarController()
        }else {
            self.window?.rootViewController = BaseNavigationController(rootViewController: LoginViewController())
        }
    }
    
}
