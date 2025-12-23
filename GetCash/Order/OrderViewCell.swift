//
//  OrderViewCell.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import UIKit
import SnapKit

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(flagImageView)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrderViewCell {
    
    func configUI(with model: settledModel) {
        
    }
    
}
