//
//  DottedLineView.swift
//  Makcha
//
//  Created by yuncoffee on 6/9/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem

final class DottedLineView: UIView {
    
    var lineColor: UIColor = .black {
        didSet { updatePath() }
    }
    var lineWidth: CGFloat = 2.0 {
        didSet { updatePath() }
    }
    var lineDashPattern: [NSNumber] = [4, 4] {
        didSet { updatePath() }
    }
    var isHorizontal: Bool = true {
        didSet { updatePath() }
    }
    var position: LinePosition = .top {
        didSet { updatePath() }
    }
    
    enum LinePosition {
        case top, bottom, left, right
    }
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = lineDashPattern
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    private func updatePath() {
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = lineDashPattern
        
        let path = CGMutablePath()
        
        switch position {
        case .top:
            path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: bounds.width, y: 0)])
        case .bottom:
            path.addLines(between: [CGPoint(x: 0, y: bounds.height), CGPoint(x: bounds.width, y: bounds.height)])
        case .left:
            path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: bounds.height)])
        case .right:
            path.addLines(between: [CGPoint(x: bounds.width, y: 0), CGPoint(x: bounds.width, y: bounds.height)])
        }
        
        shapeLayer.path = path
    }
}

#if DEBUG
struct DottedLineView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            let view = DottedLineView()
            view.lineColor = .cf(.grayScale(.gray200))
            return view
        }
    }
}
#endif
