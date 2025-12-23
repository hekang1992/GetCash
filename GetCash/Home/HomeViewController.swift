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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        fetchInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await refreshHomeData()
        }
    }
}

extension HomeViewController {
    private func setupUI() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(luxView)
        luxView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupRefresh() {
        homeView.scrollView.mj_header = MJRefreshNormalHeader { [weak self] in
            Task { [weak self] in
                await self?.refreshHomeData()
            }
        }
    }
    
    private func setupHomeViewCallbacks(_ homeView: HomeView) {
        homeView.applyBlock = { [weak self] productID in
            Task { [weak self] in
                await self?.enterInfo(with: productID)
            }
        }
        
        homeView.oneBlock = { [weak self] in
            self?.navigateToWhatViewController(title: "Loan conditions", imageName: "wht_desc_image")
        }
        
        homeView.twoBlock = { [weak self] in
            self?.navigateToWhatViewController(title: "Loan conditions", imageName: "wht_desc_image")
        }
        
        homeView.threeBlock = { [weak self] in
            self?.navigateToWhatViewController(title: "Loan conditions", imageName: "wht_desc_image")
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
            }
        } catch {
            await MainActor.run {
                homeView.scrollView.mj_header?.endRefreshing()
                debugPrint("Refresh home data failed: \(error)")
            }
        }
    }
    
    private func handleHomeInfoResponse(_ model: BaseModel) {
        guard model.hoping == "0" else { return }
        
        let settledModels = model.awe?.settled ?? []
        
        if let normalProduct = settledModels.first(where: { $0.courteous == "While" }) {
            showNormalView(with: normalProduct)
        } else {
            showLuxuryView()
        }
    }
    
    private func showNormalView(with product: settledModel) {
        homeView.model = product.inherited?.first
        homeView.isHidden = false
        luxView.isHidden = true
    }
    
    private func showLuxuryView() {
        homeView.isHidden = true
        luxView.isHidden = false
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
