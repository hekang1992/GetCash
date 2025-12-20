//
//  WhatViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit

class WhatViewController: BaseViewController {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        
        return bgImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(headView)
        
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(24)
            make.width.equalTo(346.pix())
            make.centerX.equalToSuperview()
        }
        
    }
    
}

extension WhatViewController {
    
     func setConfig(with title: String, bgImage: String) {
        headView.config(title: title)
        bgImageView.image = UIImage(named: bgImage)
    }
    
}
