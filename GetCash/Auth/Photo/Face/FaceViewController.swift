//
//  FaceViewController.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
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
    
    var type: String? {
        didSet {
            guard let type = type else { return }
            print("type=====\(type)")
        }
    }
    
    var productID: String = ""
    
    var stepArray: [residenceModel] = []
    
    private let stepView = StepScrollView()
    
    lazy var faceView: FaceView = {
        let faceView = FaceView()
        return faceView
    }()
    
    var model: BaseModel?
    
    private let viewModel = StepViewModel()
    
    private let trackViewModel = AppTrackViewModel()
    
    private let locationManager = AppLocationManager()
    
    var enterPhototime: String = ""
    
    var enterFacetime: String = ""
    
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
            self.stayLeaveClick()
        }
        
        view.addSubview(stepView)
        stepView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
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
            let photoModel = model.awe?.fane ?? faneModel()
            if photoModel.used == 1 {
                ToastManager.showMessage(message: "The verification has already been successfully completed.")
                return
            }
            alertModel(with: model)
        }
        
        faceView.twoBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            let faceModel = model.awe?.hid ?? faneModel()
            if faceModel.used == 1 {
                ToastManager.showMessage(message: "The verification has already been successfully completed.")
                return
            }
            alertModel(with: model)
        }
        
        faceView.threeBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            let photoModel = model.awe?.fane ?? faneModel()
            let faceModel = model.awe?.hid ?? faneModel()
            if photoModel.used == 1 && faceModel.used == 1 {
                self.backStepPageVc()
            }else {
                alertModel(with: model)
            }
        }
        
        self.faceView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getFaceInfo()
            }
        })
        
        Task {
            await self.getFaceInfo()
        }
        
        locationManager.getCurrentLocation { json in
            guard let json = json else { return }
            AppLocationModel.shared.locationJson = json
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
            enterPhototime = String(Int(Date().timeIntervalSince1970))
            alertPhoto()
            return
        }
        
        if photoModel.used == 1 {
            self.faceView.oneListView.twoImageView.image = UIImage(named: "upload_suce_c_image")
        }
        
        if faceModel.used == 0 {
            locationManager.getCurrentLocation { json in
                guard let json = json else { return }
                AppLocationModel.shared.locationJson = json
            }
            alertFace()
            return
        }
        
        if faceModel.used == 1 {
            self.faceView.twoListView.twoImageView.image = UIImage(named: "upload_suce_c_image")
        }
        
    }
    
    private func alertPhoto() {
        let popView = PhotoPopAlertView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.oneBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                ImagePickerHelper.takePhoto(from: self, isFront: false) { image in
                    guard let image = image else { return }
                    Task {
                        await self.takePhoto(with: image, authType: "11")
                    }
                }
            }
        }
        
        popView.twoBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                ImagePickerHelper.pickPhoto(from: self) { image in
                    guard let image = image else { return }
                    Task {
                        await self.pickPhoto(with: image)
                    }
                }
            }
        }
    }
    
    private func alertFace() {
        let popView = FacePopAlertView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.oneBlock = { [weak self] in
            guard let self = self else { return }
            enterFacetime = String(Int(Date().timeIntervalSince1970))
            self.dismiss(animated: true) {
                ImagePickerHelper.takePhoto(from: self, isFront: true) { image in
                    guard let image = image else { return }
                    Task {
                        await self.takePhoto(with: image, authType: "10")
                    }
                }
            }
        }
    }
    
    private func takePhoto(with image: UIImage, authType: String) async {
        do {
            let json = ["sets": "1", "courteous": authType, "glitter": type ?? ""]
            let imageData = image.jpegData(compressionQuality: 0.3) ?? Data()
            let model = try await viewModel.uploadIDInfo(json: json, imageData: imageData)
            if model.hoping == "0" {
                if authType == "11" {
                    await MainActor.run {
                        let modelArray = model.awe?.ridiculous ?? []
                        alertSucView(with: modelArray)
                    }
                }else if authType == "10" {
                    await self.trackPingMessageInfo(with: "4", startTime: enterFacetime)
                    await self.getFaceInfo()
                }
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch  {
            
        }
    }
    
    private func pickPhoto(with image: UIImage) async {
        do {
            let json = ["sets": "2", "courteous": "11", "glitter": type ?? ""]
            let imageData = image.jpegData(compressionQuality: 0.3) ?? Data()
            let model = try await viewModel.uploadIDInfo(json: json, imageData: imageData)
            if model.hoping == "0" {
                await MainActor.run {
                    let modelArray = model.awe?.ridiculous ?? []
                    alertSucView(with: modelArray)
                }
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch  {
            
        }
    }
    
    private func alertSucView(with modelArray: [ridiculousModel]) {
        let popView = PhotoSuccessAlertView(frame: self.view.bounds)
        popView.modelArray = modelArray
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.oneBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.savePhotoIDInfo(with: modelArray)
            }
        }
        
    }
    
    private func savePhotoIDInfo(with modelArray: [ridiculousModel]) async {
        var json = ["childhood": productID, "courteous": "11", "glitter": type ?? ""]
        for model in modelArray {
            let key = model.hoping ?? ""
            let value = model.outlived ?? ""
            json[key] = value
        }
        do {
            let model = try await viewModel.savePhotoIDInfo(json: json)
            if model.hoping == "0" {
                self.dismiss(animated: true)
                await self.trackPingMessageInfo(with: "3", startTime: enterPhototime)
                await self.getFaceInfo()
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch {
            
        }
    }
    
}

extension FaceViewController {
    
    private func trackPingMessageInfo(with type: String, startTime: String) async {
        do {
            if let locationJson = AppLocationModel.shared.locationJson {
                let palate = locationJson["palate"] ?? ""
                let communicated = locationJson["communicated"] ?? ""
                let json = ["cream": type,
                            "palate": palate,
                            "communicated": communicated,
                            "embowering": startTime,
                            "lightly": String(Int(Date().timeIntervalSince1970)),
                            "balmy": ""]
                _ = try await trackViewModel.trackMessageInfo(json: json)
            }
        } catch  {
            
        }
    }
    
}
