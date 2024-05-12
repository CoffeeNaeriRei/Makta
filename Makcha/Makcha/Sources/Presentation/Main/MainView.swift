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
    let button2 = UIButton()
    let currentTimeLabel = UILabel()
    
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
        rootView.backgroundColor = .white
        button1.setTitle("Hello", for: .normal)
        button2.setTitle("world", for: .normal)
        currentTimeLabel.attributedText = .pretendard("오늘의 시간", scale: .title)
        
        let myColor = UIColor(Color.transport(.subway(.metropolitanRailway(.line2))))
        let myColor2 = UIColor(Color.cf(.primaryScale(.primary(.medium))))
        
        let colorLine1 = UIColor(Color.transport(.subway(.metropolitanRailway(.line2))))
        let colorLine3 = UIColor(Color.transport(.subway(.metropolitanRailway(.line3))))
        let color마을버스 = UIColor(Color.transport(.bus(.gyeonggiBusType(.마을))))
        
        rootView.flex.gap(.cfSpacing(.large)).define {
            
            $0.addItem().direction(.row).define {
                $0.addItem(currentTimeLabel).grow(1)
                $0.addItem(button1)
                    .width(120).height(80)
                    .backgroundColor(myColor)
                    .cornerRadius(.cfRadius(.medium))
                $0.addItem(button2)
                    .width(120).height(80)
                    .backgroundColor(color마을버스)
                    .cornerRadius(.cfRadius(.medium))
            }
            .padding(.cfSpacing(.large))
            
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
                            .backgroundColor(colorLine1)
                            .height(100%)
                            .grow(1)
                        $0.addItem()
                            .backgroundColor(colorLine3)
                            .height(100%)
                            .grow(1)
                    }
                    .backgroundColor(color마을버스)
                    .height(100%).grow(1)
                    
                $0.addItem()
                    .backgroundColor(UIColor(Color.transport(.subway(.metropolitanRailway(.line2)))))
                    .height(100%).grow(1)
                    
                $0.addItem()
                    .backgroundColor(colorLine3)
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
