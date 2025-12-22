//
//  PersonalViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit
import SnapKit
import MJRefresh
import TYAlertController
import BRPickerView
import RxSwift
import RxCocoa

class PersonalViewController: BaseViewController {
    
    private let viewModel = PersonalViewModel()
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.config(title: name)
        }
    }
    
    var productID: String = ""
    
    var stepArray: [residenceModel] = []
    
    private let stepView = StepScrollView()
    
    var modelArray: [gotModel] = []
    
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
        tableView.register(EnterViewCell.self, forCellReuseIdentifier: "EnterViewCell")
        tableView.register(TapClickViewCell.self, forCellReuseIdentifier: "TapClickViewCell")
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
        stepView.setActiveStep(2)
        
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
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                var json = ["childhood": productID]
                for model in modelArray {
                    let type = model.remark ?? ""
                    let key = model.hoping ?? ""
                    var value = model.courteous ?? ""
                    if type == "chapel" {
                        value = model.courteous ?? ""
                    }else {
                        value = model.dead ?? ""
                    }
                    json[key] = value
                }
                Task {
                    await self.savePersonalInfo(with: json)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getPersonalInfo()
        }
    }
    
}

extension PersonalViewController {
    
    private func getPersonalInfo() async {
        do {
            let json = ["childhood": productID]
            let model = try await viewModel.getPersonalInfo(json: json)
            if model.hoping == "0" {
                self.modelArray = model.awe?.got ?? []
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
            self.tableView.reloadData()
        } catch {
            ToastManager.showMessage(message: "Network Connection Error")
        }
    }
    
    private func savePersonalInfo(with json: [String: String]) async {
        do {
            let model = try await viewModel.savePersonalInfo(json: json)
            if model.hoping == "0" {
                self.backStepPageVc()
            }else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }
        } catch {
            ToastManager.showMessage(message: "Network Connection Error")
        }
    }
    
}


extension PersonalViewController: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArray[indexPath.row]
        let remark = model.remark ?? ""
        if remark == "thought" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnterViewCell", for: indexPath) as! EnterViewCell
            cell.configEnterModel(with: model)
            cell.phoneTextChanged = { text in
                model.dead = text
                model.courteous = text
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TapClickViewCell", for: indexPath) as! TapClickViewCell
            cell.configEnterModel(with: model)
            cell.tapClickBlock = { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                if remark == "the" {
                    self.tapCityClickCell(with: model, selectCell: cell)
                }else {
                    self.tapClickCell(with: model, selectCell: cell)
                }
                
            }
            return cell
        }
    }
    
}

extension PersonalViewController {
    
    private func tapClickCell(with model: gotModel, selectCell: TapClickViewCell) {
        let popView = PopAlertEnmuView(frame: self.view.bounds)
        let modelArray = model.mortals ?? []
        
        for (index, model) in modelArray.enumerated() {
            let text = selectCell.phoneTextFiled.text ?? ""
            let target = model.planet ?? ""
            if target == text {
                popView.selectedIndex = index
            }
            popView.modelArray = modelArray
        }
        
        popView.configTitle(with: model.favourite ?? "")
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        popView.confirmBlock = { [weak self] listModel in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                selectCell.phoneTextFiled.text = listModel.planet ?? ""
                model.courteous = String(listModel.courteous ?? 0)
                model.dead = listModel.planet ?? ""
            }
        }
        
    }
    
    private func tapCityClickCell(with model: gotModel, selectCell: TapClickViewCell) {
        let cityModelArray = AppCityModel.shared.modelArray ?? []
        let listArray = AddressDecodeModel.getAddressModelArray(dataSourceArr: cityModelArray)
        
        let stringPickerView = BRTextPickerView()
        stringPickerView.pickerMode = .componentCascade
        stringPickerView.title = model.favourite ?? ""
        stringPickerView.dataSourceArr = listArray
        
        
        let customStyle = BRPickerStyle()
        customStyle.rowHeight = 44
        customStyle.language = "en"
        customStyle.doneTextColor = UIColor.init(hex: "#7895F4")
        customStyle.selectRowTextColor = UIColor.init(hex: "#7895F4")
        customStyle.pickerTextFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        customStyle.selectRowTextFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        stringPickerView.pickerStyle = customStyle
        
        stringPickerView.multiResultBlock = { models, indexs in
            if let models = models {
                let selectText = models.map { $0.text ?? "" }.joined(separator: "-")
                selectCell.phoneTextFiled.text = selectText
                model.dead = selectText
                model.courteous = selectText
            }
        }
        
        stringPickerView.show()
    }
    
}

