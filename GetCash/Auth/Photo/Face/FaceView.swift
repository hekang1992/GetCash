//
//  FaceView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FaceView: BaseView {
    
    var oneBlock: TapCilckBlock?
    var twoBlock: TapCilckBlock?
    var threeBlock: TapCilckBlock?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("Next step", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.backgroundColor = UIColor(hex: "#003BD1")
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        nextBtn.layer.cornerRadius = 24.pix()
        nextBtn.layer.masksToBounds = true
        return nextBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneListView: FaceListView = {
        let oneListView = FaceListView()
        oneListView.oneImageView.image = UIImage(named: "photo_desc_image")
        oneListView.twoImageView.image = UIImage(named: "photo_desc_btn_image")
        return oneListView
    }()
    
    lazy var twoListView: FaceListView = {
        let twoListView = FaceListView()
        twoListView.oneImageView.image = UIImage(named: "pface_desc_image")
        twoListView.twoImageView.image = UIImage(named: "pface_desc_btn_image")
        return twoListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nextBtn)
        bgView.addSubview(scrollView)
        scrollView.addSubview(oneListView)
        scrollView.addSubview(twoListView)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nextBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48.pix())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(204.pix())
        }
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(24)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(204.pix())
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
        oneListView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.oneBlock?()
        }
        
        twoListView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.twoBlock?()
        }
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.threeBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
