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

        button.tintColor = .cf(.grayScale(.black))
        button.titleLabel?.textColor = .cf(.grayScale(.black))
   
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
        reloadButtonContainer.pin.bottom(185 + 8).right(16).width(48).height(48)
        reloadButtonContainer.flex.layout()
    }

    private func setup() {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 32,
            weight: .light,
            scale: .default
        )
        let image = UIImage(systemName: "gobackward", withConfiguration: symbolConfig)?.withTintColor(.cf(.grayScale(.gray700)), renderingMode: .alwaysOriginal)

        imageView.image = image
        imageView.contentMode = .scaleToFill
        
        reloadButtonContainer.layer.shadowColor = UIColor.black.cgColor
        reloadButtonContainer.layer.shadowOffset = .init(width: 0.0, height: 3.0)
        reloadButtonContainer.layer.shadowRadius = 3.0
        reloadButtonContainer.layer.shadowOpacity = 0.2
        
        reloadButtonContainer.flex.justifyContent(.center).alignItems(.center).define {
            $0.addItem(reloadButton).position(.absolute).top(8)
            $0.addItem(imageView).position(.absolute).left(5.5).top(3.5)
        }
        .width(100%).height(100%)
        .cornerRadius(24)
        .backgroundColor(.cf(.grayScale(.white)))
        
        addSubview(collectionView)
//        addSubview(reloadButtonContainer)
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
