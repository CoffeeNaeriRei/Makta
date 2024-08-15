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
    }

    private func setup() {
        collectionView.delegate = self
        addSubview(collectionView)
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellTemplate.sizeThatFits(.init(width: collectionView.bounds.width, height: .greatestFiniteMagnitude))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        headerCellTemplate.sizeThatFits(.init(width: collectionView.bounds.width, height: .greatestFiniteMagnitude))
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
