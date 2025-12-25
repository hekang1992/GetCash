//
//  MineViewController.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import UIKit
import SnapKit
import MJRefresh

class MineViewController: BaseViewController {
    
    var baseModel: BaseModel?
    
    private let viewModel = MineViewModel()
    
    lazy var mineView: MineView = {
        let mineView = MineView()
        return mineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(headView)
        headView.backBtn.isHidden = true
        headView.config(title: "Mine")
        headView.bgView.backgroundColor = .clear
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        view.addSubview(mineView)
        mineView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.mineView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.centerInfo()
            }
        })
        
        self.mineView.cellTapBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            if pageUrl.contains(SchemeConfig.baseURL) {
                SchemeConfig.handleRoute(pageUrl: pageUrl, from: self)
            }else if pageUrl.hasPrefix("http") || pageUrl.hasPrefix("https") {
                self.goWebVc(with: pageUrl)
            }
        }
        
        self.mineView.leftBlock = {
            NotificationCenter.default.post(
                name: NSNotification.Name("changeOrderRootVC"),
                object: nil
            )
        }
        
        self.mineView.rightBlock = { [weak self] in
            guard let self = self else { return }
            let pageUrl = self.baseModel?.awe?.customerService?.first?.fully ?? ""
            self.goWebVc(with: pageUrl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.centerInfo()
        }
    }
    
}

extension MineViewController {
    
    private func centerInfo() async {
        do {
            let model = try await viewModel.mineCenterInfo()
            if model.hoping == "0" {
                self.baseModel = model
                self.mineView.config(with: model)
                self.mineView.modelArray = model.awe?.settled ?? []
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
            self.mineView.tableView.reloadData()
            await self.mineView.scrollView.mj_header?.endRefreshing()
        } catch {
            await self.mineView.scrollView.mj_header?.endRefreshing()
        }
    }
    
}
