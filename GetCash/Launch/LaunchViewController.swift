//
//  LaunchViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import IQKeyboardManagerSwift
import SnapKit

class LaunchViewController: BaseViewController {
    
    lazy var launchView: LaunchView = {
        let launchView = LaunchView()
        return launchView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(launchView)
        launchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        keyboardConfig()
        changeRootVcNoti()
    }

}

extension LaunchViewController {
    
    private func keyboardConfig() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    private func changeRootVcNoti() {
        NotificationCenter.default.post(
            name: NSNotification.Name("changeRootVc"),
            object: nil
        )
    }
    
}
