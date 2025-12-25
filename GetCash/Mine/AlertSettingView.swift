//
//  AlertSettingView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlertSettingView: BaseView {
    
    var cancelBlock: TapCilckBlock?
    
    var oneBlock: TapCilckBlock?
    
    var twoBlock: TapCilckBlock?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.contentMode = .scaleAspectFit
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
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
        bgImageView.addSubview(twoBtn)
        bgImageView.addSubview(cancelBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(343.pix())
        }
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        oneBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-100.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 180.pix(), height: 30.pix()))
            make.centerX.equalToSuperview()
        }
        twoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(oneBtn.snp.top).offset(-20.pix())
            make.size.equalTo(CGSize(width: 180.pix(), height: 40.pix()))
        }
        
        tapClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AlertSettingView {
    
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
        
        twoBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.twoBlock?()
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
