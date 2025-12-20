//
//  DotLineView.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit

class DotLineView: UIView {
    
    var lineColor: UIColor = UIColor.init(hex: "#2D4173")
    var lineWidth: CGFloat = 1.0
    var dashPattern: [NSNumber] = [2, 2]
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLine()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    private func setupLine() {
        layer.addSublayer(shapeLayer)
    }
    
    private func updatePath() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.fillColor = UIColor.clear.cgColor
    }
}
