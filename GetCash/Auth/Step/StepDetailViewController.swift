//
//  StepDetailViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit

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
            make.top.equalTo(headView.snp.bottom).offset(10)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getSetpInfo()
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
        } catch {
            
        }
    }
    
}
