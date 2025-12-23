//
//  HomeLuxuryView.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import UIKit
import SnapKit

class HomeLuxuryView: BaseView {
    
    lazy var headView: AppNavHeadView = {
        let headView = AppNavHeadView()
        headView.backBtn.isHidden = true
        headView.nameLabel.isHidden = true
        headView.backgroundColor = .clear
        return headView
    }()
    
    private struct Constants {
        static let headerHeight: CGFloat = 350
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
    
    private var items: [String] = Array(1...20).map { "项目 \($0)" }
    
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
            make.top.equalTo(headView.snp.bottom)
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as! HomeLuxuryViewCell
        
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
            
            header.configure()
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选中了: \(items[indexPath.item])")
    }
}
