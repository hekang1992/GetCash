//
//  SchemeConfig.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import Foundation

enum RoutePath: String {
    case setting = "seldom"
    case home = "who"
    case login = "that"
    case order = "voice"
    case productDetail = "her"
    
    var path: String {
        return self.rawValue
    }
    
    var fullURL: String {
        return "\(SchemeConfig.baseURL)/\(self.path)"
    }
}

class SchemeConfig {
    
    static let baseURL = "orbit://moon.ast.r"
    
    static var settingURL: String {
        return RoutePath.setting.fullURL
    }
    
    static var homeURL: String {
        return RoutePath.home.fullURL
    }
    
    static var loginURL: String {
        return RoutePath.login.fullURL
    }
    
    static var orderURL: String {
        return RoutePath.order.fullURL
    }
    
    static var productDetailURL: String {
        return RoutePath.productDetail.fullURL
    }
    
    static func handleRoute(pageUrl: String, from viewController: BaseViewController) {
        guard let routePath = extractRoutePath(from: pageUrl) else {
            handleInvalidRoute(pageUrl: pageUrl, from: viewController)
            return
        }
        
        switch routePath {
        case .setting:
            navigateToSetting(from: viewController, parameters: extractParameters(from: pageUrl))
        case .home:
            navigateToHome(from: viewController, parameters: extractParameters(from: pageUrl))
        case .login:
            navigateToLogin(from: viewController, parameters: extractParameters(from: pageUrl))
        case .order:
            navigateToOrder(from: viewController, parameters: extractParameters(from: pageUrl))
        case .productDetail:
            navigateToProductDetail(from: viewController, parameters: extractParameters(from: pageUrl))
        }
    }
    
    private static func extractRoutePath(from url: String) -> RoutePath? {
        guard url.hasPrefix(baseURL) else { return nil }
        let pathString = url.replacingOccurrences(of: "\(baseURL)/", with: "")
        let cleanPath: String
        if let queryRange = pathString.range(of: "?") {
            cleanPath = String(pathString[..<queryRange.lowerBound])
        } else {
            cleanPath = pathString
        }
        
        return RoutePath(rawValue: cleanPath)
    }
    
    private static func extractParameters(from url: String) -> [String: String] {
        var parameters: [String: String] = [:]
        
        guard let queryRange = url.range(of: "?") else {
            return parameters
        }
        
        let queryString = String(url[queryRange.upperBound...])
        let queryItems = queryString.split(separator: "&")
        
        for item in queryItems {
            let pair = item.split(separator: "=")
            if pair.count == 2 {
                let key = String(pair[0])
                let value = String(pair[1])
                parameters[key] = value
            }
        }
        
        return parameters
    }
    
    private static func handleInvalidRoute(pageUrl: String, from viewController: BaseViewController) {
        print("无效的路由URL: \(pageUrl)")
        
    }
    
    // MARK: - 具体页面导航方法
    private static func navigateToSetting(from viewController: BaseViewController, parameters: [String: String]) {
        let settingVc = SettingViewController()
        viewController.navigationController?.pushViewController(settingVc, animated: true)
    }
    
    private static func navigateToHome(from viewController: BaseViewController, parameters: [String: String]) {
        NotificationCenter.default.post(
            name: NSNotification.Name("changeRootVc"),
            object: nil
        )
    }
    
    private static func navigateToLogin(from viewController: BaseViewController, parameters: [String: String]) {
        LoginManager.clearLogin()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            NotificationCenter.default.post(
                name: NSNotification.Name("changeRootVc"),
                object: nil
            )
        }
    }
    
    private static func navigateToOrder(from viewController: BaseViewController, parameters: [String: String]) {
        print("跳转到订单页面，参数: \(parameters)")
    }
    
    private static func navigateToProductDetail(from viewController: BaseViewController, parameters: [String: String]) {
        let productID = parameters["childhood"] ?? ""
        let stepVc = StepDetailViewController()
        stepVc.productID = productID
        viewController.navigationController?.pushViewController(stepVc, animated: true)
    }
}
