//
//  LoginViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    lazy var loginView: LoginView = {
        let loginView = LoginView(frame: .zero)
        return loginView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
