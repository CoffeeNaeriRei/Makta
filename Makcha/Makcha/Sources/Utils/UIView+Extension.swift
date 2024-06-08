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

struct UILabelFactory {
    static func build(
        attributedText: NSAttributedString = .pretendard("UILabel", scale: .body),
        textAlignment: NSTextAlignment = .center,
        textColor: UIColor = .cf(.grayScale(.black))
    ) -> UILabel {
        let label = UILabel()
        
        label.attributedText = attributedText
        label.textAlignment = textAlignment
        label.textColor = textColor
        
        return label
    }
    
    static func build(
        text: String,
        textScale: Pretendard.FontScale = .body,
        textAlignment: NSTextAlignment = .center,
        textColor: UIColor = .cf(.grayScale(.black))
    ) -> UILabel {
        let label = UILabel()
        
        label.attributedText = .pretendard(text, scale: textScale)
        label.textAlignment = textAlignment
        label.textColor = textColor
        
        return label
    }
}

import RxSwift
import RxCocoa
final class CustomUITextField: UITextField {
    var textPadding = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)

    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBindings()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    private func setupBindings() {
        self.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .withUnretained(self)
            .subscribe { field, _ in
                field.focus()
            }
            .disposed(by: disposeBag)
        
        self.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .withUnretained(self)
            .subscribe { field, _ in
                field.unfocus()
            }
            .disposed(by: disposeBag)
        
        self.rx.controlEvent([.editingDidEndOnExit])
            .asObservable()
            .withUnretained(self)
            .subscribe { field, _ in
                field.unfocus()
            }
            .disposed(by: disposeBag)
    }
    
    private func focus() {
        layer.borderColor = UIColor.cf(.colorScale(.royalBlue(.medium))).cgColor
        layer.borderWidth = 1.0
        layer.shadowColor = UIColor.cf(.colorScale(.royalBlue(.medium))).cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowOpacity = 0.8
//        self.layer.shadowRadius = 4.0
    }
    
    private func unfocus() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = .zero
        layer.shadowColor = UIColor.clear.cgColor
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowOpacity = 0.0
//        self.layer.shadowRadius = 0.0
    }
}
