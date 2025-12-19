//
//  BaseTabBarController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {

        // MARK: - Root ViewControllers
        let homeVC = BaseNavigationController(
            rootViewController: HomeViewController()
        )

        let orderVC = BaseNavigationController(
            rootViewController: OrderViewController()
        )

        let mineVC = BaseNavigationController(
            rootViewController: MineViewController()
        )

        homeVC.tabBarItem = makeItem(
            normal: "home_not_selected",
            selected: "home_selected"
        )

        orderVC.tabBarItem = makeItem(
            normal: "order_not_selected",
            selected: "order_selected"
        )

        mineVC.tabBarItem = makeItem(
            normal: "mine_not_selected",
            selected: "mine_selected"
        )

        viewControllers = [homeVC, orderVC, mineVC]

        tabBar.isTranslucent = false
        tabBar.itemPositioning = .centered
        tabBar.itemWidth = 100

        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
            tabBar.selectionIndicatorImage = UIImage()
            tabBar.backgroundColor = .white
        }
    }

    // MARK: - TabBarItem Factory
    private func makeItem(normal: String, selected: String) -> UITabBarItem {

        let normalImage = UIImage(named: normal)?
            .withRenderingMode(.alwaysOriginal)

        let selectedImage = UIImage(named: selected)?
            .withRenderingMode(.alwaysOriginal)

        let item = UITabBarItem(
            title: nil,
            image: normalImage,
            selectedImage: selectedImage
        )

        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return item
    }
}
