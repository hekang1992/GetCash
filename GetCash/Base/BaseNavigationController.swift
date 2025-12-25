//
//  BaseNavigationController.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    weak var tabBarDelegate: TabBarVisibilityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        self.navigationBar.isTranslucent = false
        self.delegate = self
        
        if let gestureRecognizers = view.gestureRecognizers {
            for gesture in gestureRecognizers {
                view.removeGestureRecognizer(gesture)
            }
        }
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        let isRoot = viewController == navigationController.viewControllers.first
        tabBarDelegate?.updateTabBarVisibility(!isRoot, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        let isRoot = viewController == navigationController.viewControllers.first
        tabBarDelegate?.updateTabBarVisibility(!isRoot, animated: animated)
    }
}
