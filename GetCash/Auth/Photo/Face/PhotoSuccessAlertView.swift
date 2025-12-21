//
//  PhotoSuccessAlertView 2.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhotoSuccessAlertView: BaseView {
    
    var cancelBlock: TapCilckBlock?
    
    var oneBlock: TapCilckBlock?
    
    var modelArray: [ridiculousModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "photo_suc_dc_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "comfirm_btn_image"), for: .normal)
        oneBtn.adjustsImageWhenHighlighted = false
        return oneBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(EnterViewCell.self, forCellReuseIdentifier: "EnterViewCell")
        tableView.register(TapClickViewCell.self, forCellReuseIdentifier: "TapClickViewCell")
        tableView.isScrollEnabled = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(bgImageView)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(tableView)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 344.pix(), height: 566.pix()))
        }
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        oneBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-44)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 171.pix(), height: 43.pix()))
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(169.pix())
            make.left.right.equalToSuperview().inset(30.pix())
            make.bottom.equalTo(oneBtn.snp.top).offset(-5)
        }
        
        tapClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoSuccessAlertView {
    
    private func tapClick() {
        
        oneBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.oneBlock?()
            })
            .disposed(by: disposeBag)
        
        cancelBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.cancelBlock?()
            })
            .disposed(by: disposeBag)
        
    }
}

extension PhotoSuccessAlertView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let model = modelArray?[index]
        if index == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TapClickViewCell", for: indexPath) as! TapClickViewCell
            cell.configModel(with: model ?? ridiculousModel())
            cell.tapClickBlock = { [weak self] in
                guard let self = self else { return }
                self.endEditing(true)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnterViewCell", for: indexPath) as! EnterViewCell
            cell.configModel(with: model ?? ridiculousModel())
            cell.phoneTextChanged = { text in
                model?.outlived = text
            }
            return cell
        }
    }
}
