//
//  StepListView.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit

class StepLeftListView: BaseView {
    
    lazy var leftImageVie: UIImageView = {
        let leftImageVie = UIImageView()
        return leftImageVie
    }()
    
    lazy var rightImageVie: UIImageView = {
        let rightImageVie = UIImageView()
        return rightImageVie
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(leftImageVie)
        addSubview(rightImageVie)
        
        leftImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 208, height: 118))
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rightImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 131, height: 43))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class StepRightListView: BaseView {
    
    lazy var leftImageVie: UIImageView = {
        let leftImageVie = UIImageView()
        return leftImageVie
    }()
    
    lazy var rightImageVie: UIImageView = {
        let rightImageVie = UIImageView()
        return rightImageVie
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(leftImageVie)
        addSubview(rightImageVie)
        
        rightImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 208, height: 118))
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        leftImageVie.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 131, height: 43))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

