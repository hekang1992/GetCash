//
//  ContactViewCell.swift
//  GetCash
//
//  Created by hekang on 2025/12/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ContactViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var oneTapClickBlcok: TapCilckBlock?
    
    var twoTapClickBlcok: TapCilckBlock?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hex: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hex: "#666666")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = UIColor.init(hex: "#666666")
        twoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return twoLabel
    }()
    
    lazy var phoneView: UIView = {
        let phoneView = UIView()
        phoneView.layer.cornerRadius = 8
        phoneView.layer.masksToBounds = true
        phoneView.backgroundColor = UIColor.init(hex: "#F6F7FA")
        return phoneView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        phoneTextFiled.textColor = UIColor.init(hex: "#2D4173")
        phoneTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        phoneTextFiled.leftViewMode = .always
        return phoneTextFiled
    }()
    
    lazy var nameView: UIView = {
        let nameView = UIView()
        nameView.layer.cornerRadius = 8
        nameView.layer.masksToBounds = true
        nameView.backgroundColor = UIColor.init(hex: "#F6F7FA")
        return nameView
    }()
    
    lazy var nameTextFiled: UITextField = {
        let nameTextFiled = UITextField()
        nameTextFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        nameTextFiled.textColor = UIColor.init(hex: "#2D4173")
        nameTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        nameTextFiled.leftViewMode = .always
        return nameTextFiled
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        
        contentView.addSubview(oneLabel)
        contentView.addSubview(phoneView)
        phoneView.addSubview(phoneTextFiled)
        
        contentView.addSubview(twoLabel)
        contentView.addSubview(nameView)
        nameView.addSubview(nameTextFiled)
        
        contentView.addSubview(oneBtn)
        contentView.addSubview(twoBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(8)
            make.height.equalTo(40.pix())
            make.left.equalTo(oneLabel)
            make.centerX.equalToSuperview()
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-5.pix())
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        nameView.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(8)
            make.height.equalTo(40.pix())
            make.left.equalTo(oneLabel)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24.pix())
        }
        
        nameTextFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-5.pix())
        }
        
        oneBtn.snp.makeConstraints { make in
            make.top.equalTo(oneLabel)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(phoneView)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.top.equalTo(twoLabel)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nameView)
        }
        
        oneBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.oneTapClickBlcok?()
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.twoTapClickBlcok?()
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContactViewCell {
    
    func configWithModel(model: relationsModel) {
        nameLabel.text = model.shrunk ?? ""
        
        let pattrString = NSMutableAttributedString(string: model.sweeten ?? "", attributes: [
            .foregroundColor: UIColor.init(hex: "#8E9BBC") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        ])
        phoneTextFiled.attributedPlaceholder = pattrString
        
        let nattrString = NSMutableAttributedString(string: model.disembodied ?? "", attributes: [
            .foregroundColor: UIColor.init(hex: "#8E9BBC") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        ])
        nameTextFiled.attributedPlaceholder = nattrString
        
        oneLabel.text = model.bitter ?? ""
        twoLabel.text = model.innocently ?? ""
        
        let name = model.planet ?? ""
        let phone = model.cheeks ?? ""

        nameTextFiled.text = [name, phone].allSatisfy { $0.isEmpty } ? "" : "\(name)-\(phone)"
        
        let renewing = model.renewing ?? ""
        let mortals = model.mortals ?? []
        
        for item in mortals {
            let courteous = String(item.courteous ?? 0)
            if courteous == renewing {
                phoneTextFiled.text = item.planet ?? ""
            }
        }
        
        
    }
    
}
