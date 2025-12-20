//
//  HomeView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit
import Kingfisher

class HomeView: BaseView {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "one_home_head_image")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "one_desc_head_image")
        return twoImageView
    }()

    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "one_hohe_head_image")
        return threeImageView
    }()

    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = UIImage(named: "one_dws_image")
        return fourImageView
    }()
    
    lazy var fiveImageView: UIImageView = {
        let fiveImageView = UIImageView()
        fiveImageView.image = UIImage(named: "two_dws_image")
        return fiveImageView
    }()
    
    lazy var sixImageView: UIImageView = {
        let sixImageView = UIImageView()
        sixImageView.image = UIImage(named: "three_dws_image")
        return sixImageView
    }()
    
    lazy var footerImageView: UIImageView = {
        let footerImageView = UIImageView()
        footerImageView.image = UIImage(named: "one_home_foot_image")
        return footerImageView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(nameLabel)
        addSubview(logoImageView)
        scrollView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        scrollView.addSubview(oneImageView)
        oneImageView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(fourImageView)
        stackView.addArrangedSubview(fiveImageView)
        stackView.addArrangedSubview(sixImageView)
        scrollView.addSubview(footerImageView)
        
        oneImageView.addSubview(descImageView)
        oneImageView.addSubview(applyImageView)
        oneImageView.addSubview(moneyLabel)
        
        oneImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(430.pix())
        }
        twoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 113, height: 136))
        }
        threeImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 100.pix()))
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.centerX.equalToSuperview()
            make.top.equalTo(threeImageView.snp.bottom).offset(24)
            make.height.equalTo(102)
        }
        
        footerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.size.equalTo(CGSize(width: 346.pix(), height: 364.pix()))
            make.bottom.equalToSuperview().offset(-80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalToSuperview().offset(23)
            make.height.equalTo(20)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(30)
            make.right.equalTo(nameLabel.snp.left).offset(-6)
        }
        
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98)
            make.size.equalTo(CGSize(width: 189, height: 22))
            make.centerX.equalToSuperview()
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(79)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeView {
    
    func configure(with model: inheritedModel) {
        nameLabel.text = model.add ?? ""
        let logoUrl = model.emigrants ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        moneyLabel.text = model.casements ?? ""
    }
    
}
