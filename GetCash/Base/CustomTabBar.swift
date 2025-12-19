//
//  CustomTabBar.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit

class CustomTabBar: UIView {
    
    var didSelectIndex: ((Int) -> Void)?
    
    private let buttons: [UIButton]
    
    init(images: [(normal: String, selected: String)]) {
        
        buttons = images.enumerated().map { index, img in
            let btn = UIButton(type: .custom)
            btn.tag = index
            btn.setImage(UIImage(named: img.normal), for: .normal)
            btn.setImage(UIImage(named: img.selected), for: .selected)
            btn.adjustsImageWhenHighlighted = false
            return btn
        }
        
        super.init(frame: .zero)
        backgroundColor = .white
        
        buttons.forEach {
            $0.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
            addSubview($0)
        }
        
        buttons.first?.isSelected = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemWidth: CGFloat = 100
        let itemHeight: CGFloat = 48
        let totalWidth = itemWidth * CGFloat(buttons.count)
        let startX = (bounds.width - totalWidth) / 2
        
        for (i, btn) in buttons.enumerated() {
            btn.frame = CGRect(
                x: startX + CGFloat(i) * itemWidth,
                y: 9,
                width: itemWidth,
                height: itemHeight
            )
        }
    }
    
    @objc private func tap(_ sender: UIButton) {
        buttons.forEach { $0.isSelected = false }
        sender.isSelected = true
        didSelectIndex?(sender.tag)
    }
}
