//
//  MainCollectionView.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

import Foundation
import UIKit
import RxDataSources
import MakchaDesignSystem
import SwiftUI

final class MainCollectionView: UICollectionView {
    var rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMainCard>(
        configureCell: { _, collectionView, indexPath, cardInfo in
            let cell: MainCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: cardInfo)
            
            return cell
        }, configureSupplementaryView: { _, collectionView, _, indexPath in
            let header: MainCollectionHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            header.configure(with: "오늘 오후 22:37")
            
            return header
        }
    )
    
    init(_ collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: .zero,
                   collectionViewLayout: collectionViewLayout)
        
        let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.minimumLineSpacing = 4
        collectionViewLayout?.minimumInteritemSpacing = 0
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
                
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setup() {
        backgroundColor = UIColor(Color.cf(.grayScale(.gray100)))
        
        register(cellType: MainCollectionCell.self)
        register(supplementaryViewType: MainCollectionHeaderCell.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
    }
}
