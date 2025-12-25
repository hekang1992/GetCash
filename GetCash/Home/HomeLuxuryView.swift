//
//  HomeLuxuryView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/23.
//

import UIKit
import SnapKit

class HomeLuxuryView: BaseView {
    
    var modelArray: [inheritedModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var tapClickBlock: ((String) -> Void)?
    
    lazy var headView: AppNavHeadView = {
        let headView = AppNavHeadView()
        headView.backBtn.isHidden = true
        headView.nameLabel.isHidden = true
        headView.backgroundColor = .clear
        headView.bgView.backgroundColor = UIColor.init(hex: "#EDF0FF")
        return headView
    }()
    
    private struct Constants {
        static let headerHeight: CGFloat = 375.pix()
        static let numberOfItemsPerRow: CGFloat = 2
        static let cellSpacing: CGFloat = 12
        static let sectionInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        static let cellIdentifier = "HomeLuxuryViewCell"
        static let headerIdentifier = "HomeLuxuryHeaderView"
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeLuxuryViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.register(HomeLuxuryHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.headerIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(87.pix())
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(-10.pix())
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(60)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createLayoutSection()
        }
        return layout
    }
    
    private func createLayoutSection() -> NSCollectionLayoutSection {
        let totalSpacing = Constants.sectionInsets.left + Constants.sectionInsets.right +
        Constants.cellSpacing * (Constants.numberOfItemsPerRow - 1)
        let availableWidth = UIScreen.main.bounds.width - totalSpacing
        let itemWidth = availableWidth / Constants.numberOfItemsPerRow
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Int(Constants.numberOfItemsPerRow)
        )
        group.interItemSpacing = .fixed(Constants.cellSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.cellSpacing
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.headerHeight)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

extension HomeLuxuryView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let modelArray = modelArray else { return 0 }
        let newArray = Array(modelArray.dropFirst())
        return newArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as! HomeLuxuryViewCell
        
        if let modelArray = modelArray {
            let newArray = Array(modelArray.dropFirst())
            cell.config(with: newArray[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: Constants.headerIdentifier,
                for: indexPath
            ) as! HomeLuxuryHeaderView
            if let modelArray = modelArray {
                let model = modelArray[0]
                header.configure(with: model)
                header.tapClickBlock = { [weak self] in
                    guard let self = self else { return }
                    let productID = String(model.suspended ?? 0)
                    self.tapClickBlock?(productID)
                }
            }
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let modelArray = modelArray {
            let newArray = Array(modelArray.dropFirst())
            let productID = String(newArray[indexPath.row].suspended ?? 0)
            self.tapClickBlock?(productID)
        }
    }
}
