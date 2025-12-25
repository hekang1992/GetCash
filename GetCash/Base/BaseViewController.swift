//
//  BaseViewController.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import UIKit
import RxSwift
import TYAlertController

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var headView: AppNavHeadView = {
        let headView = AppNavHeadView()
        headView.backgroundColor = .clear
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "#EDF0FF")
    }
    
}

extension BaseViewController {
    
    func backStepPageVc() {
        guard let navigationController = self.navigationController else { return }
        if let targetVC = navigationController.viewControllers.first(where: { $0 is StepDetailViewController }) {
            navigationController.popToViewController(targetVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func goWebVc(with pageUrl: String, type: String? = "") {
        let webVc = GWebViewController()
        webVc.pageUrl = pageUrl
        webVc.type = type ?? ""
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
    func stayLeaveClick() {
        let deleteView = AlertSettingView(frame: self.view.bounds)
        deleteView.bgImageView.image = UIImage(named: "stay_leave_bg_image")
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
                self.backStepPageVc()
            }
        }
    }
    
}
