//
//  FacePopAlertView.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FacePopAlertView: BaseView {
    
    var cancelBlock: TapCilckBlock?
    
    var oneBlock: TapCilckBlock?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "photo_demo_desc_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(bgImageView)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(cancelBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 344.pix(), height: 566.pix()))
        }
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        oneBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-114)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 300.pix(), height: 40.pix()))
        }
        
        tapClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FacePopAlertView {
    
    private func tapClick() {
        
        oneBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.oneBlock?()
        })
            .disposed(by: disposeBag)
        
        cancelBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        })
            .disposed(by: disposeBag)
        
    }
}
