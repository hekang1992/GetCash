//
//  GWebViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/22.
//

import UIKit
import SnapKit
import WebKit
import StoreKit

class GWebViewController: BaseViewController {
    
    var productID: String = ""
    
    var pageUrl: String = ""
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let scriptNames = [
            "HistoryAnd", "TravelingThe", "FirstAnd",
            "WasThe", "MeasureConstructing"
        ]
        scriptNames.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.init(hex: "#EDF0FF")
        progressView.trackTintColor = UIColor.clear
        progressView.isHidden = true
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadWebPage()
    }
    
    private func setupUI() {
        
        view.addSubview(headView)
        headView.bgView.backgroundColor = .clear
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            } else {
                self.backStepPageVc()
            }
        }
    }

    private func loadWebPage() {
        guard let encodedUrlString = pageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiUrl = URLQueryHelper.buildURL(from: encodedUrlString, queryParameters: CommonParameterManager.getAPIParameters()),
              let finalUrl = URL(string: apiUrl) else {
            print("Failed to construct valid URL from: \(pageUrl)")
            return
        }
        let request = URLRequest(url: finalUrl)
        webView.load(request)
    }
    
}

extension GWebViewController: WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        let body = message.body
        print("name====\(name)")
        print("body====\(body)")
    }
}

extension GWebViewController {
    
    private func requestAppReview() {
        guard #available(iOS 14.0, *) else { return }
        
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
            return
        }
        
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
}
