//
//  StepListView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StepLeftListView: BaseView {
    
    var tapClickBlock: TapCilckBlock?
    
    lazy var leftImageVie: UIImageView = {
        let leftImageVie = UIImageView()
        return leftImageVie
    }()
    
    lazy var rightImageVie: UIImageView = {
        let rightImageVie = UIImageView()
        return rightImageVie
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(leftImageVie)
        addSubview(rightImageVie)
        addSubview(clickBtn)
        
        leftImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 208, height: 118))
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rightImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 131, height: 43))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clickBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.tapClickBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class StepRightListView: BaseView {
    
    var tapClickBlock: TapCilckBlock?
    
    lazy var leftImageVie: UIImageView = {
        let leftImageVie = UIImageView()
        return leftImageVie
    }()
    
    lazy var rightImageVie: UIImageView = {
        let rightImageVie = UIImageView()
        return rightImageVie
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(leftImageVie)
        addSubview(rightImageVie)
        addSubview(clickBtn)
        
        rightImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 208, height: 118))
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        leftImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 131, height: 43))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clickBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.tapClickBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

