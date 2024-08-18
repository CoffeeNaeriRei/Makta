//
//  MainView.swift
//  Makcha
//
//  Created by yuncoffee on 5/11/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import PinLayout
import FlexLayout

final class MainView: UIView {
    private let rootView = UIView()
    // sizeThatFits 호출을 위한 템플릿 인스턴스
    private let cellTemplate = MainCollectionCell()
    private let headerCellTemplate = MainCollectionHeaderCell()
    
    private var collectionViewLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView
    
    private let reloadButtonContainer = UIView()
    
    var reloadButton = {
        let button = UIButton()
        button.setAttributedTitle(.repet("0", size: 24), for: .normal)

        button.tintColor = .cf(.primaryScale(.primary(.medium)))
        button.titleLabel?.textColor = .cf(.primaryScale(.primary(.medium)))
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .init(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 4.0
        
        return button
    }()
    
    init() {
        collectionView = MainCollectionView(collectionViewLayout)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.pin.top(pin.safeArea)
            .horizontally().bottom(185)
        reloadButtonContainer.pin.bottom(185 + 8).right(16).width(40).height(40)
        reloadButtonContainer.flex.layout()
    }

    private func setup() {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 34,
            weight: .light,
            scale: .default
        )
        let image = UIImage(systemName: "gobackward", withConfiguration: symbolConfig)?.withTintColor(.cf(.primaryScale(.primary(.medium))), renderingMode: .alwaysOriginal)

        imageView.image = image
        imageView.contentMode = .scaleToFill
        
        reloadButtonContainer.flex.justifyContent(.center).alignItems(.center).define {
            
            $0.addItem(reloadButton).position(.absolute)
                .width(100%).height(100%)
                .cornerRadius(20)
                .backgroundColor(.white)
            $0.addItem(imageView).position(.absolute).left(0).top(-3)
        }
        
        addSubview(collectionView)
        addSubview(reloadButtonContainer)
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
