//
//  BaseView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import RxSwift
import RxCocoa

class BaseView: UIView {
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(hex: "#EDF0FF")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
