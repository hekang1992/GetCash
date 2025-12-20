//
//  AppNavHeadView.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AppNavHeadView: BaseView {
    
    var backBlock: TapCilckBlock?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_nav_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back_icon_image"), for: .normal)
        backBtn.adjustsImageWhenHighlighted = false
        return backBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hex: "#271F24")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return nameLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(bgImageView)
        bgImageView.addSubview(backBtn)
        bgImageView.addSubview(nameLabel)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.left.equalToSuperview().offset(17)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        backBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.backBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AppNavHeadView {
    
    func config(title: String) {
        nameLabel.text = title
    }
    
}
