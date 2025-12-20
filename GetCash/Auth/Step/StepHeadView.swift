//
//  StepHeadView.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit
import Kingfisher

class StepHeadView: BaseView {
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "step_head_bg_image")
        return oneImageView
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneImageView)
        oneImageView.addSubview(nameLabel)
        oneImageView.addSubview(logoImageView)
        oneImageView.addSubview(descImageView)
        oneImageView.addSubview(moneyLabel)
        oneImageView.addSubview(oneLabel)
        oneImageView.addSubview(twoLabel)
        
        oneImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StepHeadView {
    
    func setConfig(with model: sentenceModel) {
        let logoUrl = model.emigrants ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        nameLabel.text = model.add ?? ""
        
        let symbol = model.symbol ?? ""
        let suppose = String(model.suppose ?? 0)
        moneyLabel.text = String(format: "%@ %@", symbol, suppose)
        
        let hopeless = model.lord?.weeks?.shrunk ?? ""
        let ashes = model.lord?.weeks?.extraordinary ?? ""
        oneLabel.text = String(format: "%@: %@", hopeless, ashes)
        
        let blunted = model.lord?.attending?.shrunk ?? ""
        let dim = model.lord?.attending?.extraordinary ?? ""
        twoLabel.text = String(format: "%@: %@", blunted, dim)
    }
    
}
