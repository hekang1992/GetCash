//
//  HomeViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit
import MJRefresh

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
    private let loginViewModel = LoginViewModel()
    
    private let launchViewModel = LaunchViewModel()
    
    private let trackViewModel = AppTrackViewModel()
    
    private let locationManager = AppLocationManager()
    
    var baseModel: BaseModel?
    
    private lazy var homeView: HomeView = {
        let view = HomeView()
        view.isHidden = true
        setupHomeViewCallbacks(view)
        return view
    }()
    
    private lazy var luxView: HomeLuxuryView = {
        let view = HomeLuxuryView()
        view.isHidden = true
        return view
    }()
    
    var modelArray: [inheritedModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        fetchInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.homeRefreshAllApi()
        }
    }
    
    private func homeRefreshAllApi() async {
        Task {
            await setupLocation()
            await refreshHomeData()
            await uploadIDFAInfo()
        }
    }
}

extension HomeViewController {
    
    private func setupLocation() async {
        locationManager.getCurrentLocation { [weak self] json in
            
            DeviceInfoManager.getAllDeviceInfoWithDispatchGroup { deviceInfo in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: deviceInfo, options: .prettyPrinted)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        let deviceJson = ["awe": jsonString]
                        Task {
                            await self?.uploadDeviceMessage(with: deviceJson)
                        }
                    }
                } catch {
                    print("JSON===\(error)")
                }
            }
            
            print("location==🗺️==\(json ?? [:])")
            
            if let json = json {
                
                AppLocationModel.shared.locationJson = json
                Task {
                    await self?.uploadLocationMessage(with: json)
                }
            }
            
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
            _ = try await launchViewModel.uploadIDInfo(json: json)
        } catch {
            print("uploadIDFAInfo error: \(error)")
        }
    }
    
    private func uploadLocationMessage(with json: [String: String]) async {
        do {
            _ = try await loginViewModel.locationInfo(json: json)
        } catch {
            
        }
    }
    
    private func uploadDeviceMessage(with json: [String: String]) async {
        do {
            _ = try await loginViewModel.uploadDeviceInfo(json: json)
        } catch {
            
        }
    }
    
    private func setupUI() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(luxView)
        luxView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupRefresh() {
        homeView.scrollView.mj_header = MJRefreshNormalHeader { [weak self] in
            Task { [weak self] in
                await self?.homeRefreshAllApi()
            }
        }
        
        luxView.collectionView.mj_header = MJRefreshNormalHeader { [weak self] in
            Task { [weak self] in
                await self?.homeRefreshAllApi()
            }
        }
    }
    
    private func setupHomeViewCallbacks(_ homeView: HomeView) {
        homeView.applyBlock = { [weak self] productID in
            Task { [weak self] in
                await self?.enterInfo(with: productID)
                await self?.trackPingMessageInfo()
            }
        }
        
        luxView.tapClickBlock = { [weak self] productID in
            Task { [weak self] in
                await self?.enterInfo(with: productID)
            }
        }
        
        homeView.oneBlock = { [weak self] in
            self?.navigateToWhatViewController(title: "Loan conditions", imageName: "wht_desc_image")
        }
        
        homeView.twoBlock = { [weak self] in
            guard let self = self else { return }
            let pageUrl = self.baseModel?.awe?.departed?.indicated ?? ""
            self.goWebVc(with: pageUrl)
        }
        
        homeView.threeBlock = {
            NotificationCenter.default.post(
                name: NSNotification.Name("changeOrderRootVC"),
                object: nil
            )
        }
        
        homeView.fourBlock = { [weak self] in
            self?.navigateToWhatViewController(title: "Common problem", imageName: "com_ques_image")
        }
    }
    
    private func fetchInitialData() {
        Task {
            await fetchAddressInfo()
        }
    }
}

extension HomeViewController {
    private func navigateToWhatViewController(title: String, imageName: String) {
        let whatVc = WhatViewController()
        whatVc.setConfig(with: title, bgImage: imageName)
        navigationController?.pushViewController(whatVc, animated: true)
    }
}

extension HomeViewController {
    private func fetchAddressInfo() async {
        do {
            let model = try await viewModel.getAdressInfo()
            guard model.hoping == "0" else { return }
            AppCityModel.shared.modelArray = model.awe?.settled ?? []
        } catch {
            debugPrint("Fetch address info failed: \(error)")
        }
    }
    
    private func refreshHomeData() async {
        do {
            let model = try await viewModel.homeInfo()
            await MainActor.run {
                handleHomeInfoResponse(model)
                homeView.scrollView.mj_header?.endRefreshing()
                luxView.collectionView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                homeView.scrollView.mj_header?.endRefreshing()
                luxView.collectionView.mj_header?.endRefreshing()
                debugPrint("Refresh home data failed: \(error)")
            }
        }
    }
    
    private func handleHomeInfoResponse(_ model: BaseModel) {
        guard model.hoping == "0" else { return }
        
        let settledModels = model.awe?.settled ?? []
        
        self.baseModel = model
        
        if let normalProduct = settledModels.first(where: { $0.courteous == "While" }) {
            showNormalView(with: normalProduct)
        } else {
            modelArray.removeAll()
            if let normalProduct = settledModels.first(where: { $0.courteous == "luxury" }) {
                showLuxuryView(with: normalProduct)
            }
            
            if let normalProduct = settledModels.first(where: { $0.courteous == "about" }) {
                showLuxuryView(with: normalProduct)
            }
            
        }
    }
    
    private func showNormalView(with product: settledModel) {
        homeView.model = product.inherited?.first
        homeView.isHidden = false
        luxView.isHidden = true
    }
    
    private func showLuxuryView(with product: settledModel) {
        let listArray = product.inherited ?? []
        modelArray.append(contentsOf: listArray)
        luxView.modelArray = modelArray
        homeView.isHidden = true
        luxView.isHidden = false
        print("modelarray---count---\(modelArray.count)")
    }
    
    private func enterInfo(with productID: String) async {
        do {
            let json = ["childhood": productID]
            let model = try await viewModel.enterInfo(json: json)
            
            await MainActor.run {
                if model.hoping == "0", let pageUrl = model.awe?.fully {
                    handlePageUrl(pageUrl)
                } else {
                    ToastManager.showMessage(message: model.recollected ?? "")
                }
            }
        } catch {
            await MainActor.run {
                debugPrint("Enter info failed: \(error)")
            }
        }
    }
    
    private func handlePageUrl(_ pageUrl: String) {
        if pageUrl.contains(SchemeConfig.baseURL) {
            SchemeConfig.handleRoute(pageUrl: pageUrl, from: self)
        } else if pageUrl.hasPrefix("http") || pageUrl.hasPrefix("https") {
            goWebVc(with: pageUrl)
        }
    }
}

extension HomeViewController {
    
    private func trackPingMessageInfo() async {
        do {
            let starttime = UserDefaults.standard.object(forKey: "entertime") as? String ?? ""
            let endtime = UserDefaults.standard.object(forKey: "endtime") as? String ?? ""
            if !starttime.isEmpty && !endtime.isEmpty {
                if let locationJson = AppLocationModel.shared.locationJson {
                    let palate = locationJson["palate"] ?? ""
                    let communicated = locationJson["communicated"] ?? ""
                    let json = ["cream": "1",
                                "palate": palate,
                                "communicated": communicated,
                                "embowering": starttime,
                                "lightly": endtime,
                                "balmy": ""]
                    let model = try await trackViewModel.trackMessageInfo(json: json)
                    if model.hoping == "0" {
                        UserDefaults.standard.removeObject(forKey: "entertime")
                        UserDefaults.standard.removeObject(forKey: "endtime")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        } catch  {
            
        }
    }
    
}
