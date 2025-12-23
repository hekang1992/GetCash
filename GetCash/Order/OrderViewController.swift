//
//  OrderViewController.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa

class OrderViewController: BaseViewController {
    
    private enum Constants {
        static let buttonSize = CGSize(width: 110, height: 50)
        static let buttonSpacing: CGFloat = 0
        static let horizontalPadding: CGFloat = 10
        static let scrollViewHeight: CGFloat = 50
        static let topOffset: CGFloat = 10
        static let headerHeight: CGFloat = 87
    }
    
    private let viewModel = MineViewModel()
    private var buttons: [UIButton] = []
    private let selectedIndex = BehaviorRelay<Int>(value: 0)
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var oneBtn = createButton(
        normalImage: "order_one_nor_image",
        selectedImage: "order_one_sel_image",
        tag: 0
    )
    
    private lazy var twoBtn = createButton(
        normalImage: "order_two_nor_image",
        selectedImage: "order_two_sel_image",
        tag: 1
    )
    
    private lazy var threeBtn = createButton(
        normalImage: "order_three_nor_image",
        selectedImage: "order_three_sel_image",
        tag: 2
    )
    
    private lazy var fourBtn = createButton(
        normalImage: "order_four_nor_image",
        selectedImage: "order_four_sel_image",
        tag: 3
    )
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 可以在这里添加页面显示时的逻辑
    }
    
    private func setupUI() {
        setupHeaderView()
        setupScrollView()
        setupButtons()
    }
    
    private func setupHeaderView() {
        view.addSubview(headView)
        headView.backBtn.isHidden = true
        headView.config(title: "Loan order")
        headView.bgView.backgroundColor = .clear
        
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constants.headerHeight.pix())
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(Constants.topOffset)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(Constants.scrollViewHeight.pix())
        }
    }
    
    private func setupButtons() {
        buttons = [oneBtn, twoBtn, threeBtn, fourBtn]
        buttons.forEach { scrollView.addSubview($0) }
        
        setupButtonConstraints()
    }
    
    private func setupButtonConstraints() {
        var previousButton: UIButton?
        
        for button in buttons {
            button.snp.makeConstraints { make in
                if let previous = previousButton {
                    make.left.equalTo(previous.snp.right).offset(Constants.buttonSpacing)
                } else {
                    make.left.equalToSuperview().offset(Constants.horizontalPadding)
                }
                make.centerY.equalToSuperview()
                make.size.equalTo(Constants.buttonSize)
            }
            previousButton = button
        }
        
        if let lastButton = buttons.last {
            lastButton.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-Constants.horizontalPadding)
            }
        }
    }
    
    private func setupBindings() {
        Observable.merge(
            oneBtn.rx.tap.map { 0 },
            twoBtn.rx.tap.map { 1 },
            threeBtn.rx.tap.map { 2 },
            fourBtn.rx.tap.map { 3 }
        )
        .bind(to: selectedIndex)
        .disposed(by: disposeBag)
        
        selectedIndex
            .subscribe(onNext: { [weak self] index in
                self?.updateButtonSelection(selectedIndex: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func createButton(normalImage: String, selectedImage: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.setImage(UIImage(named: normalImage), for: .normal)
        button.setImage(UIImage(named: selectedImage), for: .selected)
        return button
    }
    
    private func updateButtonSelection(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            button.isSelected = (index == selectedIndex)
        }
        switch selectedIndex {
        case 0:
            print("切换到第一个分类")
        case 1:
            print("切换到第二个分类")
        case 2:
            print("切换到第三个分类")
        case 3:
            print("切换到第四个分类")
        default:
            break
        }
    }
}
