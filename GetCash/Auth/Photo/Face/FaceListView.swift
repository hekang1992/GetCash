//
//  FaceListView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class FaceListView: BaseView {
    
    var tapClickBlock: TapCilckBlock?
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        return twoImageView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(oneImageView)
        oneImageView.addSubview(twoImageView)
        addSubview(clickBtn)
        
        oneImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 330.pix(), height: 208.pix()))
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 151.pix(), height: 43.pix()))
            make.bottom.equalToSuperview().offset(-24)
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
