//
//  LoadingIndicator.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//


import UIKit
import SnapKit
import Toast_Swift

class LoadingIndicator {
    
    static let shared = LoadingIndicator()
    
    private var loadingView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private let serialQueue = DispatchQueue(label: "com.loadingindicator.queue")
    private var loadingCount: Int = 0
    
    private init() {}
    
    func show() {
        serialQueue.async {
            self.loadingCount += 1
            
            if self.loadingCount > 1 {
                return
            }
            
            DispatchQueue.main.async {
                self.setupLoadingView()
                self.showLoadingView()
            }
        }
    }
    
    func hide() {
        serialQueue.async {
            guard self.loadingCount > 0 else { return }
            
            self.loadingCount -= 1
            
            if self.loadingCount == 0 {
                DispatchQueue.main.async {
                    self.hideLoadingView()
                }
            }
        }
    }
    
    func forceHideAll() {
        serialQueue.async {
            self.loadingCount = 0
            DispatchQueue.main.async {
                self.hideLoadingView()
            }
        }
    }
    
    private func setupLoadingView() {
        guard loadingView == nil else { return }
        
        guard let window = getKeyWindow() else { return }
        
        let loadingView = UIView()
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        loadingView.alpha = 1.0

        let activityIndicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
        } else {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        
        activityIndicator.hidesWhenStopped = true
        
        loadingView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
       
        window.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        window.bringSubviewToFront(loadingView)
        
        self.loadingView = loadingView
        self.activityIndicator = activityIndicator
    }
    
    private func showLoadingView() {
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingView() {
        activityIndicator?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
        activityIndicator = nil
    }
    
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

class ToastManager {
    static func showMessage(message: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.makeToast(message, duration: 3.0, position: .center)
    }
}
