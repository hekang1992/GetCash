//
//  StepScrollView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
//


import UIKit
import SnapKit

class StepScrollView: UIView {
    var stepArray: [residenceModel] = [] {
        didSet {
            createStepButtons()
        }
    }
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private var buttons: [UIButton] = []
    
    private let buttonSize = CGSize(width: 100, height: 72)
    
    private let buttonSpacing: CGFloat = 10
    
    private let edgeInset: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    func setActiveStep(_ activeCount: Int) {
        guard activeCount >= 0 && activeCount <= buttons.count else {
            print("Invalid active count")
            return
        }
        
        for (index, button) in buttons.enumerated() {
            let isActive = index < activeCount
            button.isSelected = isActive
            updateButtonImage(button, index: index, isActive: isActive)
        }
    }
    
    private func createStepButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, model) in stepArray.enumerated() {
            let button = createButton(for: model, index: index)
            buttons.append(button)
            containerView.addSubview(button)
        }
        
        layoutButtons()
    }
    
    private func createButton(for model: residenceModel, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = index
        button.adjustsImageWhenHighlighted = false
        let name = model.blanc ?? ""
        let normalImageName = "\(name)_nor_image"
        let selectedImageName = "\(name)_sel_image"
        if let normalImage = UIImage(named: normalImageName) {
            button.setImage(normalImage, for: .normal)
        }
        
        if let selectedImage = UIImage(named: selectedImageName) {
            button.setImage(selectedImage, for: .selected)
        }
        
        return button
    }
    
    private func updateButtonImage(_ button: UIButton, index: Int, isActive: Bool) {
        
        let name = self.stepArray[index].blanc ?? ""
        
        let imageName = isActive ? "\(name)_sel_image" : "\(name)_nor_image"
        
        UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve) {
            if let image = UIImage(named: imageName) {
                button.setImage(image, for: .normal)
                button.setImage(image, for: .selected)
            }
        }
    }
    
    private func layoutButtons() {
        guard !buttons.isEmpty else { return }
        
        var previousButton: UIButton?
        
        for button in buttons {
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(buttonSize.width)
                make.height.equalTo(buttonSize.height)
                
                if let previous = previousButton {
                    make.leading.equalTo(previous.snp.trailing).offset(buttonSpacing)
                } else {
                    make.leading.equalToSuperview().offset(edgeInset)
                }
            }
            
            previousButton = button
        }
        
        if let lastButton = buttons.last {
            lastButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-edgeInset)
            }
        }
        
        updateContentSize()
    }
    
    private func updateContentSize() {
        let totalWidth = CGFloat(buttons.count) * buttonSize.width +
        CGFloat(buttons.count - 1) * buttonSpacing +
        edgeInset * 2
        
        containerView.snp.updateConstraints { make in
            make.width.equalTo(totalWidth)
        }
        
        layoutIfNeeded()
    }
}
