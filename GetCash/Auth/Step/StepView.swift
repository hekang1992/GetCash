//
//  StepView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StepView: BaseView {
    
    var tapClickBlock: ((residenceModel) -> Void)?
    
    var nextBtnClickBlock: (() -> Void)?
    
    var model: BaseModel? {
        didSet{
            guard let model = model else { return }
            if let headModel = model.awe?.sentence {
                headView.setConfig(with: headModel)
            }
            if let modelArray = model.awe?.residence {
                listViews.forEach { $0.removeFromSuperview() }
                listViews.removeAll()
                
                for (index, modelItem) in modelArray.enumerated() {
                    let listView = createListView(with: modelItem, index: index)
                    scrollView.addSubview(listView)
                    listViews.append(listView)
                }
                setupListViewsLayout()
            }
        }
    }
    
    private var listViews: [BaseView] = []
    
    lazy var headView: StepHeadView = {
        let headView = StepHeadView()
        return headView
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var lineImageView: UIImageView = {
        let lineImageView = UIImageView()
        lineImageView.image = UIImage(named: "step_line_image")
        return lineImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nextBtn)
        addSubview(scrollView)
        scrollView.addSubview(headView)
        
        nextBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48.pix())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        headView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5.pix())
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(235.pix())
        }
        
        nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.nextBtnClickBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createListView(with modelItem: residenceModel, index: Int) -> BaseView {
        let listView: BaseView
        if index % 2 == 0 {
            let leftListView = StepLeftListView()
            leftListView.snp.makeConstraints { make in
                make.height.equalTo(118)
            }
            
            let type = modelItem.blanc ?? ""
            leftListView.leftImageVie.image = UIImage(named: "\(type)_desc_image")
            
            let used = modelItem.used ?? 0
            leftListView.rightImageVie.image = used == 1 ? UIImage(named: "sel_srtp_list_image") : UIImage(named: "nor_srtp_list_image")
            
            listView = leftListView
            
            leftListView.tapClickBlock = { [weak self] in
                self?.tapClickBlock?(modelItem)
            }
            
        } else {
            let rightListView = StepRightListView()
            rightListView.snp.makeConstraints { make in
                make.height.equalTo(118)
            }
            let type = modelItem.blanc ?? ""
            rightListView.rightImageVie.image = UIImage(named: "\(type)_desc_image")
            
            let used = modelItem.used ?? 0
            rightListView.leftImageVie.image = used == 1 ? UIImage(named: "sel_srtp_list_image") : UIImage(named: "nor_srtp_list_image")
            listView = rightListView
            
            rightListView.tapClickBlock = { [weak self] in
                self?.tapClickBlock?(modelItem)
            }
            
        }
        return listView
    }
    
    
    private func setupListViewsLayout() {
        guard !listViews.isEmpty else { return }
        
        let firstListView = listViews[0]
        firstListView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(25)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        for i in 1..<listViews.count {
            let previousView = listViews[i-1]
            let currentView = listViews[i]
            
            currentView.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(25)
                make.left.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        let lastListView = listViews.last!
        lastListView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
        
        scrollView.insertSubview(lineImageView, at: 0)
        lineImageView.snp.makeConstraints { make in
            make.top.equalTo(firstListView.snp.top).offset(79)
            make.width.equalTo(263)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lastListView.snp.bottom).offset(-22)
        }
    }
    
}
