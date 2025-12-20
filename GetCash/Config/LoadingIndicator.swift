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
    private var backgroundView: UIView?
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(hex: "#EDF0FF").withAlphaComponent(0.8)
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        
        backgroundView.addSubview(activityIndicator)
        loadingView.addSubview(backgroundView)
        window.addSubview(loadingView)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        window.bringSubviewToFront(loadingView)
        
        self.loadingView = loadingView
        self.backgroundView = backgroundView
        self.activityIndicator = activityIndicator
    }
    
    private func showLoadingView() {
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingView() {
        activityIndicator?.stopAnimating()
        loadingView?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
        
        loadingView = nil
        backgroundView = nil
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
