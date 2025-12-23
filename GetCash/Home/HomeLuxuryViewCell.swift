//
//  HomeLuxuryViewCell.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import UIKit
import SnapKit

class HomeLuxuryViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "luxy_bg_cell_image")
        return imageView
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
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 167.pix(), height: 160.pix()))
            make.bottom.equalToSuperview().offset(-5.pix())
        }
        
    }
    
}
