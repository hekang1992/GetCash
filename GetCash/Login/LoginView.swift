//
//  LoginView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit

class GradientView: UIView {
    private var gradientLayer: CAGradientLayer?
    
    var colors: [UIColor] = [] {
        didSet {
            updateGradient()
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
        didSet {
            gradientLayer?.startPoint = startPoint
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet {
            gradientLayer?.endPoint = endPoint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        updateGradient()
        layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    private func updateGradient() {
        gradientLayer?.colors = colors.map { $0.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

class LoginView: BaseView {
    
    lazy var bgView: GradientView = {
        let bgView = GradientView()
        bgView.colors = [
            UIColor(hex: "#D2D9FF"),
            UIColor(hex: "#EDF0FF")
        ]
        bgView.startPoint = CGPoint(x: 0.5, y: 0.0)
        bgView.endPoint = CGPoint(x: 0.5, y: 1.0)
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_cover_bg_image")
        return bgImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(bgImageView)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

