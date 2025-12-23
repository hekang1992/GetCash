//
//  MineViewCell.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import UIKit
import SnapKit
import Kingfisher

class MineViewCell: UITableViewCell {
    
    var model: settledModel? {
        didSet {
            guard let model = model else { return }
            phoneLabel.text = model.shrunk ?? ""
            let logoUrl = model.departed ?? ""
            leftImageView.kf.setImage(with: URL(string: logoUrl))
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(hex: "#F8F8FF")
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var leftImageView: UIImageView = {
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "oc_left_click_image")
        return leftImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "right_icon_image")
        return rightImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel(frame: .zero)
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor.init(hex: "#2D4173")
        phoneLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(600))
        return phoneLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(leftImageView)
        bgView.addSubview(phoneLabel)
        bgView.addSubview(rightImageView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(42.pix())
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        leftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5.pix())
            make.size.equalTo(CGSize(width: 16.pix(), height: 16.pix()))
        }
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(9.pix())
            make.height.equalTo(20)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-5.pix())
            make.size.equalTo(CGSize(width: 16.pix(), height: 16.pix()))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
