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

}

extension HomeViewController {
    
    private func refeshHomeData() async {
        try? await Task.sleep(nanoseconds: 200_000_000_0)
        await MainActor.run {
            self.homeView.scrollView.mj_header?.endRefreshing()
        }
    }
    
}
