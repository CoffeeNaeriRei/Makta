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
    
    let button1 = UIButton()
    
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
        button1.setTitle("Hello", for: .normal)        
        rootView.flex.gap(.cfSpacing(.large)).define {
            $0.addItem(button1)
                .width(200).height(80)
                .backgroundColor(.blue)
            $0.addItem().direction(.row)
                .gap(.cfSpacing(.large))
                .padding(.cfSpacing(.large), .cfSpacing(.medium))
                .define {
                    $0.addItem()
                        .direction(.row)
                        .padding(12)
                        .justifyContent(.center)
                        .gap(.cfSpacing(.xxxlarge)).define {
                        $0.addItem()
                            .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line2)))))
                            .height(100%)
                            .grow(1)
                        $0.addItem()
                            .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line3)))))
                            .height(100%)
                            .grow(1)
                    }
                    .backgroundColor(UIColor(Color.transport(.bus(.gyeonggiBusType(.마을)))))
                    .height(100%).grow(1)
                $0.addItem()
                    .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line2)))))
                    .height(100%).grow(1)
                $0.addItem()
                    .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line3)))))
                    .height(100%).grow(1)
                $0.addItem()
                    .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line4)))))
                    .height(100%).grow(1)
            }
            .height(80)
            .border(1, .blue)
            
            $0.addItem()
                .width(400).height(200)
                .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line1)))))
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
