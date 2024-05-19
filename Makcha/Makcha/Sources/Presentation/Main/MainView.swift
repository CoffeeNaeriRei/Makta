//
//  MainView.swift
//  Makcha
//
//  Created by yuncoffee on 5/11/24.
//

import Foundation
import UIKit
import SwiftUI
import MakchaDesignSystem
import PinLayout
import FlexLayout

final class MainView: UIView {
    private var rootView = UIView()
    
    var currentTimeLabel = UILabel()
    
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
        
        rootView.pin.all(pin.safeArea)
        rootView.flex.layout()
    }
    
    private func layout() {
        currentTimeLabel.attributedText = .pretendard("오늘의 시간", scale: .title)
        
        rootView.flex.gap(.cfSpacing(.large)).define {
            $0.addItem().direction(.row).define {
                $0.addItem(currentTimeLabel).grow(1)
            }
            .padding(.cfSpacing(.large))
        }
        .border(1, .red)
    }
}

#if DEBUG
struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            MainView()
        }
    }
}
#endif
