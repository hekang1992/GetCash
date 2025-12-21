//
//  PopAlertEnmuView.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopAlertEnmuView: UIView {
    
    var selectedIndex: Int? = nil
    
    var modelArray: [mortalsModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    var cancelBlock: (() -> Void)?
    
    var confirmBlock: ((mortalsModel) -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 20
        bgView.backgroundColor = .white
        bgView.layer.masksToBounds = true
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return bgView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "dis_can_bt_image"), for: .normal)
        cancelBtn.adjustsImageWhenHighlighted = false
        return cancelBtn
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("Confirm", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.backgroundColor = UIColor(hex: "#003BD1")
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        nextBtn.layer.cornerRadius = 24.pix()
        nextBtn.layer.masksToBounds = true
        return nextBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hex: "#2D4173")
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(600))
        return nameLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(nextBtn)
        bgView.addSubview(nameLabel)
        bgView.addSubview(tableView)
        
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(365.pix())
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 48))
            make.bottom.equalToSuperview().offset(-20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(22)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalTo(nextBtn.snp.top).offset(-18)
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        nextBtn.rx.tap.bind(onNext: {  [weak self] in
            guard let self = self else { return }
            if selectedIndex == nil {
                ToastManager.showMessage(message: "Please select one option")
                return
            }
            if let model = modelArray?[selectedIndex ?? 0] {
                self.confirmBlock?(model)
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopAlertEnmuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.pix()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.textLabel?.text = model?.planet ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        if indexPath.section == selectedIndex {
            cell.backgroundColor = UIColor.init(hex: "#7895F3")
            cell.textLabel?.textColor = UIColor.init(hex: "#FFFFFF")
            cell.layer.borderWidth = 1.5
            cell.layer.borderColor = UIColor.init(hex: "#2D4173").cgColor
        } else {
            cell.backgroundColor = UIColor.init(hex: "#E8EBF3")
            cell.textLabel?.textColor = UIColor(hex: "#2D4173")
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.section {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.section
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension PopAlertEnmuView {
    
    func configTitle(with name: String) {
        nameLabel.text = name
    }
}
