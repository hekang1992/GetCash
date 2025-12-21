//
//  BaseViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import RxSwift

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
    
}
