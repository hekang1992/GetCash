//
//  HomeLuxuryViewCell.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/23.
//

import UIKit
import SnapKit
import Kingfisher

class HomeLuxuryViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "luxy_bg_cell_image")
        return imageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 12
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#2D4173")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return nameLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .left
        moneyLabel.textColor = UIColor.init(hex: "#2D4173")
        moneyLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.textColor = UIColor.init(hex: "#8E9BBC")
        descLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return descLabel
    }()
    
    lazy var lineView: DotLineView = {
        let lineView = DotLineView()
        return lineView
    }()
    
    lazy var applyImageView: UIImageView = {
        let applyImageView = UIImageView()
        applyImageView.image = UIImage(named: "appc_ap_imge_da")
        return applyImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.addSubview(logoImageView)
        imageView.addSubview(nameLabel)
        imageView.addSubview(moneyLabel)
        imageView.addSubview(descLabel)
        imageView.addSubview(lineView)
        imageView.addSubview(applyImageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 167.pix(), height: 160.pix()))
            make.bottom.equalToSuperview().offset(-5.pix())
        }
        
        logoImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
            make.height.equalTo(29)
        }
        
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(moneyLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(13.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }
        applyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 135.pix(), height: 36.pix()))
            make.bottom.equalToSuperview().offset(-10.pix())
        }
    }
    
}

extension HomeLuxuryViewCell {
    
    func config(with model: inheritedModel) {
        let logoUrl = model.emigrants ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        nameLabel.text = model.add ?? ""
        
        moneyLabel.text = model.casements ?? ""
        let one = model.narrative ?? ""
        let two = model.dim ?? ""
        descLabel.text = String(format: "%@ | %@", one, two)
    }
    
}
