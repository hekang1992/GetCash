//
//  FaceViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit
import SnapKit
import MJRefresh
import TYAlertController

class FaceViewController: BaseViewController {
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.config(title: name)
        }
    }
    
    var type: String = ""
    
    var productID: String = ""
    
    var stepArray: [residenceModel] = []
    
    private let stepView = StepScrollView()
    
    lazy var faceView: FaceView = {
        let faceView = FaceView()
        return faceView
    }()
    
    private let viewModel = StepViewModel()
    
    var model: BaseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(hex: "#C1CFFF")
        
        view.addSubview(headView)
        headView.bgView.backgroundColor = .clear
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(stepView)
        stepView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(72)
        }
        stepView.stepArray = stepArray
        stepView.setActiveStep(1)
        
        view.addSubview(faceView)
        faceView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
        
        faceView.oneBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            alertModel(with: model)
        }
        
        faceView.twoBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            alertModel(with: model)
        }
        
        faceView.threeBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            alertModel(with: model)
        }
        
        self.faceView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getFaceInfo()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getFaceInfo()
        }
    }
    
}

extension FaceViewController {
    
    private func getFaceInfo() async {
        do {
            let json = ["childhood": productID]
            let model = try await viewModel.getFaceInfo(json: json)
            if model.hoping == "0" {
                
                self.model = model
                
                alertModel(with: model)
                
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
            await self.faceView.scrollView.mj_header?.endRefreshing()
        } catch {
            await self.faceView.scrollView.mj_header?.endRefreshing()
        }
    }
    
}

extension FaceViewController {
    
    private func alertModel(with model: BaseModel) {
        
        let photoModel = model.awe?.fane ?? faneModel()
        
        let faceModel = model.awe?.hid ?? faneModel()
        
        if photoModel.used == 0 {
            alertPhoto()
            return
        }
        
        if faceModel.used == 0 {
            alertFace()
            return
        }
        
    }
    
    private func alertPhoto() {
        let popView = FacePopAlertView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.oneBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    private func alertFace() {
        
    }
    
}
