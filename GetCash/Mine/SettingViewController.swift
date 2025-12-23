//
//  SettingViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa
import TYAlertController

class SettingViewController: BaseViewController {
    
    private let viewModel = MineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(headView)
        headView.config(title: "Settings")
        headView.bgView.backgroundColor = .clear
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        let headImagView = UIImageView()
        headImagView.image = UIImage(named: "setting_logo_image")
        view.addSubview(headImagView)
        headImagView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 80.pix(), height: 116.pix()))
        }
        
        let numLabel = UILabel()
        numLabel.text = "Version Number 1.0.0"
        numLabel.textAlignment = .center
        numLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        numLabel.textColor = UIColor.init(hex: "#8E9BBC")
        view.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImagView.snp.bottom).offset(4)
            make.height.equalTo(24)
        }
        
        let logoutBtn = UIButton(type: .custom)
        logoutBtn.setImage(UIImage(named: "out_del_image"), for: .normal)
        logoutBtn.adjustsImageWhenHighlighted = true
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numLabel.snp.bottom).offset(32.pix())
            make.size.equalTo(CGSize(width: 343.pix(), height: 48.pix()))
        }
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("Cancel the account", for: .normal)
        deleteBtn.setTitleColor(UIColor.init(hex: "#8E9BBC"), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.size.equalTo(CGSize(width: 140.pix(), height: 24.pix()))
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: "#8E9BBC")
        lineView.layer.cornerRadius = 5
        lineView.layer.masksToBounds = true
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(deleteBtn)
            make.height.equalTo(1)
        }
        
        deleteBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.deleteClick()
        }).disposed(by: disposeBag)
        
        logoutBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.logoutClick()
        }).disposed(by: disposeBag)
    }
    
}

extension SettingViewController {
    
    private func deleteClick() {
        let deleteView = AlertSettingView(frame: self.view.bounds)
        deleteView.bgImageView.image = UIImage(named: "dele_click_image")
        let alertVc = TYAlertController(alert: deleteView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        deleteView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        deleteView.twoBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        deleteView.oneBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                Task {
                    await self.settingInfo(with: "1")
                }
            }
        }
    }
    
    private func logoutClick() {
        let deleteView = AlertSettingView(frame: self.view.bounds)
        deleteView.bgImageView.image = UIImage(named: "logout_click_image")
        let alertVc = TYAlertController(alert: deleteView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        deleteView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        deleteView.twoBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        deleteView.oneBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                Task {
                    await self.settingInfo(with: "2")
                }
            }
        }
    }
    
}

extension SettingViewController {
    
    private func settingInfo(with type: String) async {
        do {
            if type == "1" {
                let model = try await viewModel.deleteCenterInfo()
                if model.hoping == "0" {
                    deleteLoginMessage()
                }else {
                    ToastManager.showMessage(message: model.recollected ?? "")
                }
            }else {
                let model = try await viewModel.logoutCenterInfo()
                if model.hoping == "0" {
                    deleteLoginMessage()
                }else {
                    ToastManager.showMessage(message: model.recollected ?? "")
                }
            }
        } catch {
            
        }
    }
    
    private func deleteLoginMessage() {
        LoginManager.clearLogin()
        NotificationCenter.default.post(
            name: NSNotification.Name("changeRootVc"),
            object: nil
        )
    }
    
}
