//
//  EnterViewCell.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EnterViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var phoneTextChanged: ((String?) -> Void)?
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(phoneTextFiled)
        
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
            make.right.equalToSuperview().offset(-5.pix())
        }
        
        phoneTextFiled
            .rx
            .text
            .subscribe(onNext: { [weak self] text in
                self?.phoneTextChanged?(text)
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EnterViewCell {
    
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
        
        let rejoined = model.rejoined ?? 0
        phoneTextFiled.keyboardType = rejoined == 1 ? .numberPad : .default
        
    }
    
}
