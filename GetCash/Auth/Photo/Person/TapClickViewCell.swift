//
//  TapClickViewCell.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TapClickViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var tapClickBlock: TapCilckBlock?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#666666")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hex: "#F6F7FA")
        return bgView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        phoneTextFiled.textColor = UIColor.init(hex: "#2D4173")
        phoneTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        phoneTextFiled.leftViewMode = .always
        return phoneTextFiled
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "right_icon_image")
        return bgImageView
    }()
    
    lazy var tapClickBtn: UIButton = {
        let tapClickBtn = UIButton(type: .custom)
        return tapClickBtn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(phoneTextFiled)
        bgView.addSubview(bgImageView)
        contentView.addSubview(tapClickBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(40.pix())
            make.left.equalTo(nameLabel)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18.pix())
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-35.pix())
        }
        
        bgImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10.pix())
            make.width.height.equalTo(20)
        }
        
        tapClickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapClickBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.tapClickBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TapClickViewCell {
    
    func configModel(with model: ridiculousModel) {
        nameLabel.text = model.warning ?? ""
        let attrString = NSMutableAttributedString(string: model.warning ?? "", attributes: [
            .foregroundColor: UIColor.init(hex: "#8E9BBC") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        phoneTextFiled.text = model.outlived ?? ""
    }
    
    func configEnterModel(with model: gotModel) {
        nameLabel.text = model.shrunk ?? ""
        let attrString = NSMutableAttributedString(string: model.favourite ?? "", attributes: [
            .foregroundColor: UIColor.init(hex: "#8E9BBC") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        
        phoneTextFiled.text = model.dead ?? ""
        
    }
    
}
