//
//  MineView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture
import RxCocoa

class MineView: BaseView {
    
    var modelArray: [settledModel] = []
    
    var cellTapBlock: ((String) -> Void)?
    
    var leftBlock: (() -> Void)?
    
    var rightBlock: (() -> Void)?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "cen_head_image")
        return headImageView
    }()
    
    lazy var appNameLabel: UILabel = {
        let appNameLabel = UILabel(frame: .zero)
        appNameLabel.text = "Get Cash"
        appNameLabel.textAlignment = .left
        appNameLabel.textColor = UIColor.init(hex: "#2D4173")
        appNameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(800))
        return appNameLabel
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel(frame: .zero)
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor.init(hex: "#2D4173")
        phoneLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(600))
        return phoneLabel
    }()
    
    lazy var leftImageView: UIImageView = {
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "oc_left_click_image")
        return leftImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "oc_right_click_image")
        return rightImageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MineViewCell.self, forCellReuseIdentifier: "MineViewCell")
        tableView.isScrollEnabled = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(headImageView)
        headImageView.addSubview(appNameLabel)
        headImageView.addSubview(phoneLabel)
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(rightImageView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(60)
        }
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 330.pix(), height: 112.pix()))
        }
        appNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(31.pix())
            make.left.equalToSuperview().offset(96.pix())
            make.height.equalTo(24.pix())
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(4)
            make.left.equalTo(appNameLabel)
            make.height.equalTo(18.pix())
        }
        leftImageView.snp.makeConstraints { make in
            make.left.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 168.pix(), height: 80.pix()))
        }
        rightImageView.snp.makeConstraints { make in
            make.right.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 168.pix(), height: 80.pix()))
        }
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(headImageView)
            make.right.equalTo(headImageView)
            make.top.equalTo(leftImageView.snp.bottom).offset(20)
            make.height.equalTo(350.pix())
            make.bottom.equalToSuperview().offset(-10)
        }
        
        leftImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.leftBlock?()
        }).disposed(by: disposeBag)
        
        rightImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.rightBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MineView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineViewCell", for: indexPath) as! MineViewCell
        let model = modelArray[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArray[indexPath.row]
        let pageUrl = model.fully ?? ""
        self.cellTapBlock?(pageUrl)
    }
    
    func config(with model: BaseModel) {
        phoneLabel.text = model.awe?.userInfo?.userphone ?? ""
    }
    
}
