//
//  LaunchView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit

class LaunchView: BaseView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "start_page")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
