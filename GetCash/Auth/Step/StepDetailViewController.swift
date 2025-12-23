//
//  StepDetailViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit
import MJRefresh

class StepDetailViewController: BaseViewController{
    
    var productID: String = ""
    
    let viewModel = StepViewModel()
    
    var model: BaseModel?
    
    lazy var setpView: StepView = {
        let setpView = StepView()
        return setpView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(setpView)
        setpView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        
        setpView.tapClickBlock = { [weak self] model in
            guard let self = self else { return }
            let isAuth = model.used ?? 0
            let type = model.blanc ?? ""
            let name = model.shrunk ?? ""
            let pageUrl = model.fully ?? ""
            if isAuth == 1 {
                shouldGoVc(with: type, name: name, pageUrl: pageUrl)
            }else {
                setpView.nextBtnClickBlock?()
            }
        }
        
        setpView.nextBtnClickBlock = { [weak self] in
            guard let self = self else { return }
            if let model = self.model?.awe?.de {
                let type = model.blanc ?? ""
                let name = model.shrunk ?? ""
                let pageUrl = model.fully ?? ""
                shouldGoVc(with: type, name: name, pageUrl: pageUrl)
            }
        }
        
        self.setpView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getSetpInfo()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getSetpInfo()
        }
    }
    
}

extension StepDetailViewController {
    
    private func shouldGoVc(with authType: String, name: String, pageUrl: String) {
        if authType == "few" {
            Task {
                await self.getFaceInfo(with: name)
            }
        }else if authType == "frequently" {
            let personalVc = PersonalViewController()
            personalVc.name = name
            personalVc.productID = productID
            personalVc.stepArray = self.model?.awe?.residence ?? []
            self.navigationController?.pushViewController(personalVc, animated: true)
        }else if authType == "gratitude" {
            let workVc = WorkViewController()
            workVc.name = name
            workVc.productID = productID
            workVc.stepArray = self.model?.awe?.residence ?? []
            self.navigationController?.pushViewController(workVc, animated: true)
        }else if authType == "The" {
            let contactVc = ContactViewController()
            contactVc.name = name
            contactVc.productID = productID
            contactVc.stepArray = self.model?.awe?.residence ?? []
            self.navigationController?.pushViewController(contactVc, animated: true)
        }else if authType == "variety" {
            self.goWebVc(with: pageUrl)
        }else {
            Task {
                await self.applyOrderInfo()
            }
        }
    }
    
}

extension StepDetailViewController {
    
    private func getSetpInfo() async {
        do {
            let json = ["childhood": productID]
            let model = try await viewModel.setpInfo(json: json)
            if model.hoping == "0" {
                self.model = model
                self.setpView.model = model
                self.headView.config(title: model.awe?.sentence?.add ?? "")
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
            await self.setpView.scrollView.mj_header?.endRefreshing()
        } catch {
            await self.setpView.scrollView.mj_header?.endRefreshing()
        }
    }
    
    private func getFaceInfo(with name: String) async {
        do {
            let json = ["childhood": productID]
            let model = try await viewModel.getFaceInfo(json: json)
            if model.hoping == "0" {
                let photoModel = model.awe?.fane ?? faneModel()
                
                if photoModel.used == 0 {
                    let listVc = AuthIDListViewController()
                    listVc.name = name
                    listVc.productID = productID
                    listVc.modelArray = model.awe?.pardon ?? []
                    listVc.recModelArray = model.awe?.pardon ?? []
                    listVc.otherModelArray = model.awe?.quickness ?? []
                    listVc.stepArray = self.model?.awe?.residence ?? []
                    self.navigationController?.pushViewController(listVc, animated: true)
                    return
                }
                
                let faceVc = FaceViewController()
                faceVc.name = name
                faceVc.productID = productID
                faceVc.stepArray = self.model?.awe?.residence ?? []
                self.navigationController?.pushViewController(faceVc, animated: true)
                
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch {
            
        }
    }
    
    private func applyOrderInfo() async {
        do {
            let chiefly = self.model?.awe?.sentence?.chiefly ?? ""
            let suppose = String(self.model?.awe?.sentence?.suppose ?? 0)
            let died = self.model?.awe?.sentence?.died ?? ""
            let reported = String(self.model?.awe?.sentence?.reported ?? 0)
            
            let json = ["chiefly": chiefly,
                        "suppose": suppose,
                        "died": died,
                        "reported": reported
            ]
            let model = try await viewModel.applyOrderIDInfo(json: json)
            if model.hoping == "0" {
                let pageUrl = model.awe?.fully ?? ""
                self.goWebVc(with: pageUrl)
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch {
            
        }
    }
    
}
