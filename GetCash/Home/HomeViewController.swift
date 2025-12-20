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
    
    let viewModel = HomeViewModel()
    
    lazy var homeView: HomeView = {
        let homeView = HomeView()
        return homeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.homeView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.refeshHomeData()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.refeshHomeData()
        }
    }
    
}

extension HomeViewController {
    
    private func refeshHomeData() async {
        do {
            let model = try await viewModel.homeInfo()
            if model.hoping == "0" {
                let settledModelArray = model.awe?.settled ?? []
                for (index, model) in settledModelArray.enumerated() {
                    let courteous = model.courteous ?? ""
                    if courteous == "While" {
                        let modelArray = model.inherited ?? []
                        self.homeView.configure(with: modelArray[0])
                    }
                }
            }
            await MainActor.run {
                self.homeView.scrollView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.homeView.scrollView.mj_header?.endRefreshing()
            }
        }
    }
    
}
