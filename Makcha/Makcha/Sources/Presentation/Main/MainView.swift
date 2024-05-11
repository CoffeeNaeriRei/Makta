//
//  MainView.swift
//  Makcha
//
//  Created by yuncoffee on 5/11/24.
//

import Foundation
import UIKit
import MakchaDesignSystem
import PinLayout
import FlexLayout

final class MainView: UIView {
    private var rootView = UIView()
    
    var button1: UIButton {
        let button = UIButton()
        
        button.setTitle("Hello", for: .normal)
        
        return button
    }
    
    init() {
        super.init(frame: .zero)
        layout()
        addSubview(rootView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootView.pin.all()
        rootView.flex.layout()
    }
    
    private func layout() {
        rootView.flex.define {
            $0.addItem(button1)
                .width(200).height(80)
                .backgroundColor(.blue)
        }
        .border(1, .red)
    }
}

#if DEBUG
import SwiftUI
struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            MainView()
        }
    }
}
#endif
