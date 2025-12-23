//
//  HomeView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

class HomeView: BaseView {
    
    var applyBlock: ((String) -> Void)?
    
    var oneBlock: TapCilckBlock?
    
    var twoBlock: TapCilckBlock?
    
    var threeBlock: TapCilckBlock?
    
    var fourBlock: TapCilckBlock?
    
    var model: inheritedModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.add ?? ""
            let logoUrl = model.emigrants ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            moneyLabel.text = model.casements ?? ""
            
            let hopeless = model.hopeless ?? ""
            let ashes = model.ashes ?? ""
            oneLabel.text = String(format: "%@: %@", hopeless, ashes)
            
            let blunted = model.blunted ?? ""
            let dim = model.dim ?? ""
            twoLabel.text = String(format: "%@: %@", blunted, dim)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "one_home_head_image")
        oneImageView.isUserInteractionEnabled = true
        return oneImageView
    }()
    
    lazy var goldImageView: UIImageView = {
        let goldImageView = UIImageView()
        goldImageView.image = UIImage(named: "gold_bg_c_image")
        return goldImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "one_desc_head_image")
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "one_hohe_head_image")
        return threeImageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = UIImage(named: "one_dws_image")
        return fourImageView
    }()
    
    lazy var fiveImageView: UIImageView = {
        let fiveImageView = UIImageView()
        fiveImageView.image = UIImage(named: "two_dws_image")
        return fiveImageView
    }()
    
    lazy var sixImageView: UIImageView = {
        let sixImageView = UIImageView()
        sixImageView.image = UIImage(named: "three_dws_image")
        return sixImageView
    }()
    
    lazy var footerImageView: UIImageView = {
        let footerImageView = UIImageView()
        footerImageView.image = UIImage(named: "one_home_foot_image")
        return footerImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#000000")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(900))
        return nameLabel
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "oc_desc_iamge")
        return descImageView
    }()
    
    lazy var applyImageView: UIImageView = {
        let applyImageView = UIImageView()
        applyImageView.image = UIImage(named: "apply_bt_image")
        return applyImageView
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = UIColor.init(hex: "#FFFFFF")
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont.systemFont(ofSize: 64, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = UIColor.init(hex: "#000000")
        oneLabel.textAlignment = .left
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = UIColor.init(hex: "#000000")
        twoLabel.textAlignment = .left
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return twoLabel
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        return applyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(nameLabel)
        addSubview(logoImageView)
        scrollView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        scrollView.addSubview(oneImageView)
        oneImageView.addSubview(twoImageView)
        oneImageView.addSubview(goldImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(fourImageView)
        stackView.addArrangedSubview(fiveImageView)
        stackView.addArrangedSubview(sixImageView)
        scrollView.addSubview(footerImageView)
        
        oneImageView.addSubview(descImageView)
        oneImageView.addSubview(moneyLabel)
        oneImageView.addSubview(oneLabel)
        oneImageView.addSubview(twoLabel)
        oneImageView.addSubview(applyImageView)
        oneImageView.addSubview(applyBtn)
        
        oneImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(430.pix())
        }
        twoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 113, height: 136))
        }
        goldImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.bottom.equalTo(twoImageView.snp.bottom).offset(-20)
            make.size.equalTo(CGSize(width: 61, height: 61))
        }
        threeImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 100.pix()))
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.centerX.equalToSuperview()
            make.top.equalTo(threeImageView.snp.bottom).offset(24)
            make.height.equalTo(102)
        }
        
        footerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.size.equalTo(CGSize(width: 346.pix(), height: 364.pix()))
            make.bottom.equalToSuperview().offset(-80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalToSuperview().offset(23)
            make.height.equalTo(20)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(30)
            make.right.equalTo(nameLabel.snp.left).offset(-6)
        }
        
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98.pix())
            make.size.equalTo(CGSize(width: 189, height: 22))
            make.centerX.equalToSuperview()
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(79)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moneyLabel.snp.bottom).offset(16.pix())
            make.height.equalTo(17)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(8.pix())
            make.height.equalTo(17)
        }
        
        applyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 242.pix(), height: 66.pix()))
            make.bottom.equalToSuperview().offset(-90.pix())
        }
        
        applyBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapClick()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeView {
    
    private func tapClick() {
        
        applyBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = model else { return }
            let suspended = String(model.suspended ?? 0)
            self.applyBlock?(suspended)
        }).disposed(by: disposeBag)
        
        threeImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.oneBlock?()
        }).disposed(by: disposeBag)
        
        fourImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.twoBlock?()
        }).disposed(by: disposeBag)
        
        fiveImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.threeBlock?()
        }).disposed(by: disposeBag)
        
        sixImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.fourBlock?()
        }).disposed(by: disposeBag)
        
    }
    
}
