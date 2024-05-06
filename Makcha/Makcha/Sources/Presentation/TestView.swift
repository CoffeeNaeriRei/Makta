//
//  TestView.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import MakchaDesignSystem
import SwiftUI

public final class TestView: UIView {
    
    private let rootFlexContainer = UIView()
    
    let plusButton = UIButton(configuration: .filled())
    let subtractButton = UIButton(configuration: .filled())
    let count = UILabel()
    let footer = UILabel()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        plusButton.setTitle("+", for: .normal)
        subtractButton.setTitle("-", for: .normal)
        
        count.textAlignment = .center
        count.font = UIFont.systemFont(ofSize: 60.0)
        
        footer.text = "테스트 완"
        footer.textColor = UIColor(Color.cf(.colorScale(.fuchsia(.dark))))
        footer.attributedText = .pretendard("HELLO\nWORLD", scale: .largeTitle)
        footer.numberOfLines = 0
        
        rootFlexContainer.flex.width(100%).direction(.column).padding(12).define { flex in
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(plusButton).grow(1).marginRight(10)
                flex.addItem(subtractButton).grow(1)
            }
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem().direction(.column).paddingLeft(12).define { flex in
                    flex.addItem(count)
                }
            }
            
            flex.addItem().height(1).marginTop(12).backgroundColor(.lightGray)
            flex.addItem(footer).marginTop(12)
        }
        
        addSubview(rootFlexContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
}
