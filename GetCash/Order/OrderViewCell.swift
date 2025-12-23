//
//  OrderViewCell.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import UIKit
import SnapKit
import Kingfisher

class OrderViewCell: UITableViewCell {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "oli_cell_bg_image")
        return bgImageView
    }()
    
    lazy var flagImageView: UIImageView = {
        let flagImageView = UIImageView()
        flagImageView.image = UIImage(named: "oli_cell_flag_image")
        return flagImageView
    }()
    
    lazy var flagLabel: UILabel = {
        let flagLabel = UILabel()
        flagLabel.textAlignment = .center
        flagLabel.textColor = UIColor.init(hex: "#FFFFFF")
        flagLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(800))
        return flagLabel
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
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.textColor = UIColor.init(hex: "#2D4173")
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return timeLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(flagImageView)
        flagImageView.addSubview(flagLabel)
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(moneyLabel)
        bgImageView.addSubview(descLabel)
        bgImageView.addSubview(timeLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 346.pix(), height: 153.pix()))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15.pix())
        }
        flagImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 134.pix(), height: 40.pix()))
        }
        flagLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8.pix())
        }
        logoImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.height.equalTo(20)
        }
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(logoImageView.snp.bottom).offset(8.pix())
            make.height.equalTo(29)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(moneyLabel.snp.bottom).offset(2.pix())
            make.height.equalTo(15)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(descLabel.snp.bottom).offset(8.pix())
            make.height.equalTo(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrderViewCell {
    
    func configUI(with model: settledModel) {
        let logoUrl = model.emigrants ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        
        nameLabel.text = model.add ?? ""
        flagLabel.text = model.lends ?? ""
        moneyLabel.text = model.grasshoppers ?? ""
        descLabel.text = model.married ?? ""
        let one = model.agnes ?? ""
        let two = model.permitted ?? ""
        timeLabel.text = String(format: "%@: %@", one, two)
    }
    
}
