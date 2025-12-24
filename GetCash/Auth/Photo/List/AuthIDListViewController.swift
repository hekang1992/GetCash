//
//  AuthIDListViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AuthIDListViewController: BaseViewController {
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.config(title: name)
        }
    }
    
    var modelArray: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var recModelArray: [String] = []
    
    var otherModelArray: [String] = []
    
    var stepArray: [residenceModel] = []
    
    var entertime: String = ""
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.isSelected = true
        oneBtn.setImage(UIImage(named: "nor_sel_image"), for: .normal)
        oneBtn.setImage(UIImage(named: "rec_sel_image"), for: .selected)
        oneBtn.adjustsImageWhenHighlighted = false
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "other_nor_image"), for: .normal)
        twoBtn.setImage(UIImage(named: "other_sel_image"), for: .selected)
        twoBtn.adjustsImageWhenHighlighted = false
        return twoBtn
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("Next step", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.backgroundColor = UIColor(hex: "#003BD1")
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        nextBtn.layer.cornerRadius = 24.pix()
        nextBtn.layer.masksToBounds = true
        return nextBtn
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "aut_list_id_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
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
        tableView.register(AuthIDListViewCell.self, forCellReuseIdentifier: "AuthIDListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    var productID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headView)
        
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.stayLeaveClick()
        }
        
        setupUI()
        tapClick()
    }
    
}

extension AuthIDListViewController {
    
    private func setupUI() {
        
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        view.addSubview(nextBtn)
        view.addSubview(bgImageView)
        bgImageView.addSubview(tableView)
        
        oneBtn.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(167)
            make.height.equalTo(60)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(167)
            make.height.equalTo(60)
        }
        
        bgImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 346.pix(), height: 518.pix()))
            make.centerX.equalToSuperview()
            make.top.equalTo(oneBtn.snp.bottom).offset(15)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(50)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48.pix())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func tapClick() {
        oneBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                oneBtn.isSelected = true
                twoBtn.isSelected = false
                self.modelArray = self.recModelArray
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                oneBtn.isSelected = false
                twoBtn.isSelected = true
                self.modelArray = self.otherModelArray
            })
            .disposed(by: disposeBag)
    }
    
}

extension AuthIDListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthIDListViewCell", for: indexPath) as! AuthIDListViewCell
        let name = self.modelArray?[indexPath.row] ?? ""
        cell.setConfig(with: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.modelArray?[indexPath.row] ?? ""
        let faceVc = FaceViewController()
        faceVc.stepArray = stepArray
        faceVc.productID = productID
        faceVc.type = type
        faceVc.name = name ?? ""
        self.navigationController?.pushViewController(faceVc, animated: true)
    }
    
}
