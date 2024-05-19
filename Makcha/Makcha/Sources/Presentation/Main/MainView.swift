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
    // test용
    var currentPathCountLabel = UILabel()
    var collectionViewLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView
    
    init() {
        collectionView = MainCollectionView(collectionViewLayout)
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
        currentPathCountLabel.attributedText = .pretendard("갯수", scale: .headline)
        
        rootView.flex.gap(.cfSpacing(.large)).define {
            $0.addItem().direction(.column).define {
                $0.direction(.row).define {
                    $0.addItem(currentTimeLabel).grow(1)
                    $0.addItem(currentPathCountLabel).grow(1)
                }
                $0.addItem(collectionView)
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
