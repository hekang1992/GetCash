//
//  HomeView.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit

class HomeView: BaseView {

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
        return oneImageView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        scrollView.addSubview(oneImageView)
        oneImageView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(fourImageView)
        stackView.addArrangedSubview(fiveImageView)
        stackView.addArrangedSubview(sixImageView)
        scrollView.addSubview(footerImageView)
        
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
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
