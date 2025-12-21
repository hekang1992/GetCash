//
//  PaddedLabel.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }
}
