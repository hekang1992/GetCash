//
//  HomeLuxuryHeaderView.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeLuxuryHeaderView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    var tapClickBlock: (() -> Void)?
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "one_home_head_image")
        oneImageView.isUserInteractionEnabled = true
        return oneImageView
    }()
    
    lazy var goldImageView: UIImageView = {
        let goldImageView = UIImageView()
        goldImageView.image = UIImage(named: "gold_bg_c_image")
        return goldImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "one_desc_head_image")
        return twoImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#000000")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(900))
        return nameLabel
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "oc_desc_iamge")
        return descImageView
    }()
    
    lazy var applyImageView: UIImageView = {
        let applyImageView = UIImageView()
        applyImageView.image = UIImage(named: "apply_bt_image")
        return applyImageView
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = UIColor.init(hex: "#FFFFFF")
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont.systemFont(ofSize: 64, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = UIColor.init(hex: "#000000")
        oneLabel.textAlignment = .left
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = UIColor.init(hex: "#000000")
        twoLabel.textAlignment = .left
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return twoLabel
    }()
    
    lazy var moreImageView: UIImageView = {
        let moreImageView = UIImageView()
        moreImageView.image = UIImage(named: "lux_more_bg_image")
        return moreImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        return applyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(oneImageView)
        addSubview(moreImageView)
        oneImageView.addSubview(goldImageView)
        oneImageView.addSubview(descImageView)
        oneImageView.addSubview(moneyLabel)
        oneImageView.addSubview(oneLabel)
        oneImageView.addSubview(twoLabel)
        oneImageView.addSubview(applyImageView)
        oneImageView.addSubview(applyBtn)
        oneImageView.addSubview(logoImageView)
        oneImageView.addSubview(nameLabel)
        oneImageView.addSubview(twoImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(315.pix())
        }
        twoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 113, height: 136))
        }
        goldImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.bottom.equalTo(twoImageView.snp.bottom).offset(-10)
            make.size.equalTo(CGSize(width: 61, height: 61))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.pix())
            make.centerX.equalToSuperview().offset(23)
            make.height.equalTo(20)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(30)
            make.right.equalTo(nameLabel.snp.left).offset(-6)
        }
        
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56.pix())
            make.size.equalTo(CGSize(width: 189, height: 22))
            make.centerX.equalToSuperview()
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(79)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moneyLabel.snp.bottom).offset(16.pix())
            make.height.equalTo(17)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(8.pix())
            make.height.equalTo(17)
        }
        
        applyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 242.pix(), height: 66.pix()))
            make.bottom.equalToSuperview().offset(-25.pix())
        }
        
        moreImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 166.pix(), height: 24.pix()))
            make.centerX.equalToSuperview()
        }
        
        applyBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        applyBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tapClickBlock?()
        }).disposed(by: disposeBag)
        
    }
    
}

extension HomeLuxuryHeaderView {
    
    func configure(with model: inheritedModel) {
        nameLabel.text = model.add ?? ""
        let logoUrl = model.emigrants ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        
        moneyLabel.text = model.casements ?? ""
        
        let hopeless = model.hopeless ?? ""
        let ashes = model.ashes ?? ""
        oneLabel.text = String(format: "%@: %@", hopeless, ashes)
        
        let blunted = model.blunted ?? ""
        let dim = model.dim ?? ""
        twoLabel.text = String(format: "%@: %@", blunted, dim)
    }
    
}
