//
//  LaunchViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import IQKeyboardManagerSwift
import SnapKit
import Alamofire
import AdSupport
import AppTrackingTransparency
import FBSDKCoreKit

class LaunchViewController: BaseViewController {
    
    private let viewModel = LaunchViewModel()
    
    lazy var launchView: LaunchView = {
        let view = LaunchView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardConfig()
        
        view.addSubview(launchView)
        launchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NetworkMonitor.shared.startListening { [weak self] status in
            guard let self = self else { return }
            
            if status == .reachableViaCellular || status == .reachableViaWiFi {
                NetworkMonitor.shared.stopListening()
                Task {
                    await self.requestAll()
                }
            }
        }
    }
}

// MARK: - Private
extension LaunchViewController {
    
    private func keyboardConfig() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    private func changeRootVcNoti() {
        NotificationCenter.default.post(
            name: NSNotification.Name("changeRootVc"),
            object: nil
        )
    }
    
    private func requestAll() async {
        async let idfaTask: Void = getIDFA()
        async let initTask: Void = initInfo()
        
        _ = await (idfaTask, initTask)
        
        changeRootVcNoti()
    }
    
    private func getIDFA() async {
        guard #available(iOS 14, *) else { return }
        
        let status = await ATTrackingManager.requestTrackingAuthorization()
        
        switch status {
        case .authorized, .denied, .notDetermined:
            await uploadIDFAInfo()
        case .restricted:
            print("IDFA ===== restricted")
        @unknown default:
            print("IDFA ===== unknown")
        }
    }
    
    private func uploadIDFAInfo() async {
        do {
            let table = DeviceConfig.getIDFV()
            let insisted = DeviceConfig.getIDFA()
            let json: [String: String] = [
                "table": table,
                "insisted": insisted
            ]
            let _ = try await viewModel.uploadIDInfo(json: json)
        } catch {
            print("uploadIDFAInfo error: \(error)")
        }
    }
    
    private func initInfo() async {
        do {
            let json: [String: String] = [
                "lateness": Locale.preferredLanguages.first ?? "",
                "recollect": String(HTTPProxyInfo.proxyStatus.rawValue),
                "strongly": String(HTTPProxyInfo.vpnStatus.rawValue)
            ]
            let model = try await viewModel.appInitInfo(json: json)
            
            if model.hoping == "0" {
                if let fmodel = model.awe?.aether {
                    uploadFacebook(with: fmodel)
                }
            }
        } catch {
            print("initInfo error: \(error)")
        }
    }
    
    private func uploadFacebook(with model: aetherModel) {
        Settings.shared.displayName = model.mortal ?? ""
        Settings.shared.appURLSchemeSuffix = model.boundless ?? ""
        Settings.shared.appID = model.mould ?? ""
        Settings.shared.clientToken = model.unsphered ?? ""
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
    }
}

