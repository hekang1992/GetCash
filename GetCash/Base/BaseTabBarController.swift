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

    private func setupViewControllers() {
        let homeVC = BaseNavigationController(rootViewController: HomeViewController())
        let orderVC = BaseNavigationController(rootViewController: OrderViewController())
        let mineVC = BaseNavigationController(rootViewController: MineViewController())
        viewControllers = [homeVC, orderVC, mineVC]
    }

    private func setupCustomTabBar() {

        // 隐藏系统 tabBar
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
