//
//  MainCollectionView.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import RxDataSources

final class MainCollectionView: UICollectionView {
    // 기존 CollectionView의 DataSource를 대체하기 위한 RxCollectionViewDataSource
    let rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMainCard>(
        configureCell: { _, collectionView, indexPath, cardInfo in
            let cell: MainCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: cardInfo)
            
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, _, indexPath in
            let header: MainCollectionHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
//            print(#line, dataSource.sectionModels[indexPath.section].model)
            header.configure(with: dataSource.sectionModels[indexPath.section].model)
            
            return header
        }
    )
    
    init(_ collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        // 생성 시 `UICollectionViewFlowLayout` 일 경우 기본 레이아웃 설정
        let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.minimumLineSpacing = 4
        collectionViewLayout?.minimumInteritemSpacing = 0
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
                
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionView 초기 설정 Cell 등록
    private func setup() {
        backgroundColor = UIColor(Color.cf(.grayScale(.gray100)))
        
        register(cellType: MainCollectionCell.self)
        register(
            supplementaryViewType: MainCollectionHeaderCell.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )
    }
}
