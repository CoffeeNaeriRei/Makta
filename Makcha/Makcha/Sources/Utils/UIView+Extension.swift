//
//  UIView+Extension.swift
//  Makcha
//
//  Created by yuncoffee on 6/6/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem

// MARK: 그라데이션을 만드는 뷰
final class GradientView: UIView {
    private var colors: [UIColor] = []
    private var gradientLayer: CAGradientLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setGradientColors(_ colors: [UIColor]) {
        self.colors = colors
        gradientLayer.colors = colors.map { $0.cgColor }
    }

    func setGradientDirection(startPoint: CGPoint, endPoint: CGPoint) {
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}
