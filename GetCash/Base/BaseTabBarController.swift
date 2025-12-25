//
//  BaseTabBarController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit

class BaseTabBarController: UITabBarController {

    private let customTabBar = CustomTabBar(
        images: [
            ("home_not_selected", "home_selected"),
            ("order_not_selected", "order_selected"),
            ("mine_not_selected", "mine_selected")
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
    }

    override var selectedIndex: Int {
        didSet {
            customTabBar.select(index: selectedIndex)
        }
    }

    private func setupViewControllers() {
        let homeVC = BaseNavigationController(rootViewController: HomeViewController())
        let orderVC = BaseNavigationController(rootViewController: OrderViewController())
        let mineVC = BaseNavigationController(rootViewController: MineViewController())

        homeVC.tabBarDelegate = self
        orderVC.tabBarDelegate = self
        mineVC.tabBarDelegate = self

        viewControllers = [homeVC, orderVC, mineVC]
    }

    private func setupCustomTabBar() {
        tabBar.isHidden = true

        customTabBar.didSelectIndex = { [weak self] index in
            self?.selectedIndex = index
        }

        view.addSubview(customTabBar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let height: CGFloat = 65
        let bottom = view.safeAreaInsets.bottom

        customTabBar.frame = CGRect(
            x: 0,
            y: view.bounds.height - height - bottom * 0.7,
            width: view.bounds.width,
            height: height + bottom * 0.7
        )
    }
}

// MARK: - TabBarVisibilityDelegate
extension BaseTabBarController: TabBarVisibilityDelegate {

    func updateTabBarVisibility(_ hidden: Bool, animated: Bool) {

        let height: CGFloat = 65
        let bottom = view.safeAreaInsets.bottom
        let targetY = hidden
            ? view.bounds.height
            : view.bounds.height - height - bottom * 0.7

        let frame = CGRect(
            x: 0,
            y: targetY,
            width: view.bounds.width,
            height: height + bottom * 0.7
        )

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.customTabBar.frame = frame
            }
        } else {
            customTabBar.frame = frame
        }
    }
}

protocol TabBarVisibilityDelegate: AnyObject {
    func updateTabBarVisibility(_ hidden: Bool, animated: Bool)
}
