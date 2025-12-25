//
//  OrderViewController.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
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

    private let viewModel = OrderViewModel()
    private var buttons: [UIButton] = []
    private let selectedIndex = BehaviorRelay<Int>(value: 0)
    private var type: String = "4"
    private var modelArray: [settledModel] = []

    /// ✅ 用来防止首次进入时重复请求
    private var isFirstLoad = true

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
        tableView.register(OrderViewCell.self, forCellReuseIdentifier: "OrderViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    lazy var emptyView: OrderEmptyView = {
        let emptyView = OrderEmptyView(frame: .zero)
        emptyView.isHidden = true
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    /// ✅ 必须保留
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.orderListInfo()
        }
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
        view.addSubview(tableView)
        view.addSubview(emptyView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(Constants.topOffset)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(Constants.scrollViewHeight.pix())
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10.pix())
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(60)
        }

        emptyView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10.pix())
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(60)
        }

        emptyView.setTapHandler {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
        }

        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            guard let self = self else { return }
            Task {
                await self.orderListInfo()
            }
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
                    make.left.equalTo(previous.snp.right)
                } else {
                    make.left.equalToSuperview().offset(Constants.horizontalPadding)
                }
                make.centerY.equalToSuperview()
                make.size.equalTo(Constants.buttonSize)
            }
            previousButton = button
        }

        buttons.last?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-Constants.horizontalPadding)
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
                guard let self = self else { return }

                // ✅ 首次进入，交给 viewWillAppear，不重复请求
                if self.isFirstLoad {
                    self.isFirstLoad = false
                    self.updateButtonUI(selectedIndex: index)
                    return
                }

                self.updateButtonSelection(selectedIndex: index)
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

    /// 仅更新 UI，不请求
    private func updateButtonUI(selectedIndex: Int) {
        buttons.enumerated().forEach {
            $0.element.isSelected = $0.offset == selectedIndex
        }
    }

    /// UI + 网络请求
    private func updateButtonSelection(selectedIndex: Int) {
        updateButtonUI(selectedIndex: selectedIndex)

        let typeMap = ["4", "7", "6", "5"]
        self.type = typeMap[selectedIndex]

        Task {
            await self.orderListInfo()
        }
    }
}

// MARK: - UITableView

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelArray.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "OrderViewCell",
            for: indexPath
        ) as! OrderViewCell

        cell.configUI(with: modelArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArray[indexPath.row]
        let pageUrl = model.dancing ?? ""

        if pageUrl.contains(SchemeConfig.baseURL) {
            SchemeConfig.handleRoute(pageUrl: pageUrl, from: self)
        } else if pageUrl.hasPrefix("http") {
            goWebVc(with: pageUrl)
        }
    }
}

// MARK: - Request

extension OrderViewController {

    private func orderListInfo() async {
        do {
            let json = ["futurity": type]
            let model = try await viewModel.orderListInfo(json: json)

            if model.hoping == "0" {
                modelArray = model.awe?.settled ?? []
                emptyView.isHidden = !modelArray.isEmpty
            } else {
                ToastManager.showMessage(message: model.recollected ?? "")
            }

            tableView.reloadData()
            await tableView.mj_header?.endRefreshing()
        } catch {
            await tableView.mj_header?.endRefreshing()
        }
    }
}
