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
import RxSwift
import RxCocoa

class GWebViewController: BaseViewController {
    
    private enum Constants {
        static let estimatedProgressKeyPath = "estimatedProgress"
        static let progressViewHeight: CGFloat = 2
        static let animationDuration: TimeInterval = 0.3
        static let hideProgressDelay: TimeInterval = 0.3
        static let headViewHeight: CGFloat = 87.pix()
        static let scriptNames = [
            "necks",
            "moderate",
            "taking",
            "extremely",
            "leaned",
            "shoulder",
            "rattling"
        ]
    }
    
    // MARK: - 属性
    var productID: String = ""
    var pageUrl: String = ""
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        Constants.scriptNames.forEach {
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
        progressView.progressTintColor = UIColor(hex: "#FFA500")
        progressView.trackTintColor = .clear
        progressView.isHidden = true
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadWebPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    @MainActor
    deinit {
        removeObserver()
    }
    
    private func setupUI() {
        setupHeadView()
        setupWebView()
        setupProgressView()
    }
    
    private func setupHeadView() {
        view.addSubview(headView)
        headView.bgView.backgroundColor = .clear
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constants.headViewHeight)
        }
        
        headView.backBlock = { [weak self] in
            self?.handleBackAction()
        }
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupProgressView() {
        webView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.progressViewHeight)
        }
    }
    
    private func setupBindings() {
        addProgressObserver()
        setupTitleBinding()
    }
    
    private func addProgressObserver() {
        webView.addObserver(
            self,
            forKeyPath: Constants.estimatedProgressKeyPath,
            options: .new,
            context: nil
        )
    }
    
    private func setupTitleBinding() {
        webView.rx.observe(String.self, "title")
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] title in
                self?.updateNavigationTitle(title)
            })
            .disposed(by: disposeBag)
    }
    
    private func removeObserver() {
        if webView.observationInfo != nil {
            webView.removeObserver(
                self,
                forKeyPath: Constants.estimatedProgressKeyPath
            )
        }
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == Constants.estimatedProgressKeyPath else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
            return
        }
        
        updateProgressView()
    }
    
    private func updateProgressView() {
        let progress = Float(webView.estimatedProgress)
        progressView.progress = progress
        
        if progress >= 1.0 {
            hideProgressView()
        } else if progressView.isHidden {
            showProgressView()
        }
    }
    
    private func showProgressView() {
        progressView.isHidden = false
        progressView.alpha = 1
    }
    
    private func hideProgressView() {
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: Constants.hideProgressDelay,
            options: .curveEaseOut,
            animations: {
                self.progressView.alpha = 0
            },
            completion: { _ in
                self.progressView.isHidden = true
                self.progressView.progress = 0
                self.progressView.alpha = 1
            }
        )
    }
    
    private func loadWebPage() {
        guard let finalURL = constructFinalURL() else {
            print("Failed to construct valid URL from: \(pageUrl)")
            return
        }
        
        let request = URLRequest(url: finalURL)
        webView.load(request)
    }
    
    private func constructFinalURL() -> URL? {
        guard let encodedUrlString = pageUrl.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return nil
        }
        
        guard let apiUrl = URLQueryHelper.buildURL(
            from: encodedUrlString,
            queryParameters: CommonParameterManager.getAPIParameters()
        ) else {
            return nil
        }
        
        return URL(string: apiUrl)
    }
    
    private func updateNavigationTitle(_ title: String) {
        headView.nameLabel.text = title
    }
    
    private func handleBackAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            backStepPageVc()
        }
    }
}

// MARK: - WKNavigationDelegate
extension GWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressViewImmediately()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressViewImmediately()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideProgressViewImmediately()
    }
    
    private func hideProgressViewImmediately() {
        progressView.isHidden = true
        progressView.progress = 0
    }
}

extension GWebViewController: WKScriptMessageHandler {
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        handleScriptMessage(message)
    }
    
    private func handleScriptMessage(_ message: WKScriptMessage) {
        switch message.name {
        case "necks":
            handleNecksScript()
        case "moderate":
            handleModerateScript(message.body)
        case "taking":
            handleTakingScript()
        case "extremely":
            handleExtremelyScript()
        case "leaned":
            handleLeanedScript()
        case "shoulder":
            handleShoulderScript()
        case "rattling":
            handleRattlingScript()
        default:
            handleUnknownScript()
        }
    }
    
    private func handleNecksScript() {
        self.backStepPageVc()
    }
    
    private func handleModerateScript(_ body: Any) {
        guard let bodyArray = body as? [String],
              let pageUrl = bodyArray.first else {
            return
        }
        
        if pageUrl.contains(SchemeConfig.baseURL) {
            SchemeConfig.handleRoute(pageUrl: pageUrl, from: self)
        } else if pageUrl.hasPrefix("http") || pageUrl.hasPrefix("https") {
            self.pageUrl = pageUrl
            loadWebPage()
        }
    }
    
    private func handleTakingScript() {
        NotificationCenter.default.post(
            name: NSNotification.Name("changeRootVc"),
            object: nil
        )
    }
    
    private func handleExtremelyScript() {
        requestAppReview()
    }
    
    private func handleLeanedScript() {
        // 空实现 - 根据需求添加逻辑
    }
    
    private func handleShoulderScript() {
        // 空实现 - 根据需求添加逻辑
    }
    
    private func handleRattlingScript() {
        // 空实现 - 根据需求添加逻辑
    }
    
    private func handleUnknownScript() {
        // 处理未知脚本
    }
    
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

