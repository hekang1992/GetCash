//
//  OrderEmptyView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderEmptyView: UIView {
    
    typealias TapHandler = () -> Void
    
    private let disposeBag = DisposeBag()
    
    private var tapHandler: TapHandler?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_olic_image")
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "orderEmpty.backgroundImage"
        return imageView
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "empty_olic_desc_image"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.accessibilityIdentifier = "orderEmpty.actionButton"
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTapHandler(_ handler: @escaping TapHandler) {
        self.tapHandler = handler
    }
    
    private func setupUI() {
        addSubview(backgroundImageView)
        addSubview(actionButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 256))
            make.centerY.equalToSuperview().offset(-85)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 151, height: 43))
        }
    }
    
    private func bindActions() {
        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tapHandler?()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(backgroundImage: UIImage? = nil, buttonImage: UIImage? = nil) {
        if let backgroundImage = backgroundImage {
            backgroundImageView.image = backgroundImage
        }
        
        if let buttonImage = buttonImage {
            actionButton.setImage(buttonImage, for: .normal)
        }
    }
}
