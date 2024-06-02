//
//  SearchPathView.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import PinLayout
import FlexLayout

final class SearchPathView: UIView {
    private let rootView = UIView()
    
    let startLocationLabel = {
        let label = UILabel()
        label.attributedText = .pretendard("test", scale: .title)
        label.textColor = UIColor(Color.cf(.colorScale(.blue(.mediumLight))))
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        rootView.flex.define {
            $0.addItem(startLocationLabel)
        }
        .border(1, .red)

        addSubview(rootView)
    }
    
    private func layout() {
        rootView.pin.all()
        rootView.flex.layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
}
