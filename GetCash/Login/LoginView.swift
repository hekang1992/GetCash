//
//  LoginView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginView: BaseView {
    
    private lazy var containerView = UIView()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "login_desc_image")
        return oneImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.layer.cornerRadius = 10
        oneView.layer.masksToBounds = true
        oneView.layer.borderWidth = 1
        oneView.layer.borderColor = UIColor.init(hex: "#2D4173").cgColor
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.layer.cornerRadius = 10
        twoView.layer.masksToBounds = true
        twoView.layer.borderWidth = 1
        twoView.layer.borderColor = UIColor.init(hex: "#2D4173").cgColor
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var voiceBtn: UIButton = {
        let voiceBtn = UIButton(type: .custom)
        voiceBtn.setImage(UIImage(named: "voice_click_image"), for: .normal)
        voiceBtn.adjustsImageWhenHighlighted = false
        return voiceBtn
    }()
    
    lazy var agreeBtn: UIButton = {
        let agreeBtn = UIButton(type: .custom)
        agreeBtn.isSelected = true
        agreeBtn.setImage(UIImage(named: "agreement_nor_image"), for: .normal)
        agreeBtn.setImage(UIImage(named: "agreement_sel_image"), for: .selected)
        return agreeBtn
    }()
    
    lazy var agreeLabel: UILabel = {
        let agreeLabel = UILabel()
        agreeLabel.numberOfLines = 0
        agreeLabel.textAlignment = .center
        agreeLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        agreeLabel.textColor = UIColor.init(hex: "#2D4173")
        let fullText = "I have read and agree to <Privacy Policy>."
        let policyText = "<Privacy Policy>"
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hex: "#2D4173"), range: NSRange(location: 0, length: attributedString.length))
        if let range = fullText.range(of: policyText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(hex: "#003BD1"), range: nsRange)
        }
        agreeLabel.attributedText = attributedString
        return agreeLabel
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Log in", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = UIColor(hex: "#003BD1")
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        loginBtn.layer.cornerRadius = 24.pix()
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.text = "+63"
        oneLabel.textColor = UIColor.init(hex: "#000000")
        oneLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return oneLabel
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "Mobile phone number", attributes: [
            .foregroundColor: UIColor.init(hex: "#8E9BBC") as Any,
            .font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        phoneTextFiled.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        phoneTextFiled.textColor = UIColor.init(hex: "#000000")
        return phoneTextFiled
    }()
    
    lazy var codeTextFiled: UITextField = {
        let codeTextFiled = UITextField()
        codeTextFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "Verification code", attributes: [
            .foregroundColor: UIColor.init(hex: "#8E9BBC") as Any,
            .font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        ])
        codeTextFiled.attributedPlaceholder = attrString
        codeTextFiled.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        codeTextFiled.textColor = UIColor.init(hex: "#000000")
        codeTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 20, 10))
        codeTextFiled.leftViewMode = .always
        return codeTextFiled
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitle("Get code", for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.backgroundColor = UIColor(hex: "#7895F4")
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        codeBtn.layer.cornerRadius = 10
        codeBtn.layer.masksToBounds = true
        return codeBtn
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        tapClick()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    
    private func setupUI() {
        addSubview(bgImageView)
        addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(oneImageView)
        containerView.addSubview(oneView)
        containerView.addSubview(twoView)
        containerView.addSubview(voiceBtn)
        containerView.addSubview(agreeBtn)
        containerView.addSubview(agreeLabel)
        containerView.addSubview(loginBtn)
        
        oneView.addSubview(oneLabel)
        oneView.addSubview(phoneTextFiled)
        
        twoView.addSubview(codeTextFiled)
        twoView.addSubview(codeBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }
        
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(83)
            make.left.equalTo(containerView).offset(108.pix())
            make.size.equalTo(CGSize(width: 202, height: 101))
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(60)
            make.centerX.equalTo(containerView)
            make.size.equalTo(CGSize(width: 327.pix(), height: 52.pix()))
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(32)
            make.centerX.equalTo(containerView)
            make.size.equalTo(CGSize(width: 327.pix(), height: 52.pix()))
        }
        
        voiceBtn.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom).offset(32)
            make.centerX.equalTo(containerView)
            make.size.equalTo(CGSize(width: 327.pix(), height: 52.pix()))
        }
        
        agreeBtn.snp.makeConstraints { make in
            make.top.equalTo(voiceBtn.snp.bottom).offset(62)
            make.left.equalTo(voiceBtn).offset(25)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        
        agreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(agreeBtn)
            make.left.equalTo(agreeBtn.snp.right).offset(8)
            make.height.equalTo(15)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 340.pix(), height: 48.pix()))
            make.top.equalTo(agreeLabel.snp.bottom).offset(24)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(-20)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.equalTo(oneLabel.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
        }
        
        codeTextFiled.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.right.equalToSuperview().offset(-120)
        }
        
        codeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 89, height: 36))
        }
    }
    
}

extension LoginView {
    
    private func tapClick() {
        agreeBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            agreeBtn.isSelected.toggle()
        }).disposed(by: disposeBag)
    }
    
}
