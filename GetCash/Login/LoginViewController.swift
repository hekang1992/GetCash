//
//  LoginViewController.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    let viewModel = LoginViewModel()
    
    private let locationManager = AppLocationManager()
    
    private var countdownTimer: Timer?
    
    private var remainingSeconds = 60
    
    lazy var loginView: LoginView = {
        let loginView = LoginView(frame: .zero)
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.codeBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.requestCodeInfo(type: "1")
            }
        }
        
        loginView.voiceBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.requestCodeInfo(type: "2")
            }
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.toLoginInfo()
            }
        }
        
        locationManager.getCurrentLocation { [weak self] json in
            guard let json = json else { return }
            print("location==🗺️==\(json)")
            AppLocationModel.shared.locationJson = json
            Task {
                await self?.uploadLocationMessage(with: json)
            }
        }
        let entertime = String(Int(Date().timeIntervalSince1970))
        UserDefaults.standard.set(entertime, forKey: "entertime")
        UserDefaults.standard.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCountdown()
    }
    
    @MainActor
    deinit {
        stopCountdown()
    }
    
}

extension LoginViewController {
    
    private func startCountdown() {
        remainingSeconds = 60
        loginView.updateVerificationButton(isEnabled: false)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            if self.remainingSeconds > 0 {
                self.loginView.updateVerificationButton(title: "\(self.remainingSeconds)s", isEnabled: false)
            } else {
                self.stopCountdown()
                self.loginView.updateVerificationButton(title: "Get code", isEnabled: true)
            }
        }
        
        loginView.updateVerificationButton(title: "\(remainingSeconds)s", isEnabled: false)
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func requestCodeInfo(type: String) async {
        do {
            let phone = self.loginView.phoneTextFiled.text ?? ""
            if phone.isEmpty {
                ToastManager.showMessage(message: "Please Input Your Phone")
                return
            }
            let json = ["stars": phone]
            if type == "2" {
                let model = try await viewModel.voiceCodeInfo(json: json)
                if model.hoping == "0" {
                    self.loginView.codeTextFiled.becomeFirstResponder()
                }
                ToastManager.showMessage(message: model.recollected ?? "")
            }else {
                let model = try await viewModel.codeInfo(json: json)
                if model.hoping == "0" {
                    self.startCountdown()
                    self.loginView.codeTextFiled.becomeFirstResponder()
                }
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch {
            
        }
    }
    
    private func toLoginInfo() async {
        do {
            let phone = self.loginView.phoneTextFiled.text ?? ""
            let code = self.loginView.codeTextFiled.text ?? ""
            let isSureAgreement = self.loginView.isSureAgreement
            if phone.isEmpty {
                ToastManager.showMessage(message: "Please Input Your Phone")
                return
            }
            if code.isEmpty {
                ToastManager.showMessage(message: "Please input verification code")
                return
            }
            if !isSureAgreement {
                ToastManager.showMessage(message: "Please read and confirm the agreement first.")
                return
            }
            self.loginView.phoneTextFiled.resignFirstResponder()
            self.loginView.codeTextFiled.resignFirstResponder()
            let json = ["studded": phone, "unclouded": code]
            let model = try await viewModel.loginInfo(json: json)
            if model.hoping == "0" {
                let phone = model.awe?.studded ?? ""
                let token = model.awe?.extreme ?? ""
                LoginManager.saveLogin(phone: phone, token: token)
                let endtime = String(Int(Date().timeIntervalSince1970))
                UserDefaults.standard.set(endtime, forKey: "endtime")
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async {
                    self.changeRootVcNoti()
                }
            }
            ToastManager.showMessage(message: model.recollected ?? "")
        } catch {
            
        }
    }
    
}

extension LoginViewController {
    
    private func uploadLocationMessage(with json: [String: String]) async {
        do {
            _ = try await viewModel.locationInfo(json: json)
        } catch {
            
        }
    }
    
    private func changeRootVcNoti() {
        NotificationCenter.default.post(
            name: NSNotification.Name("changeRootVc"),
            object: nil
        )
    }
    
}
