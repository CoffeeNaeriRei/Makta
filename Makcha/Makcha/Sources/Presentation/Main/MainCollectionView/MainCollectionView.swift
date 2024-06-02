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
import RxSwift
import RxDataSources

final class MainCollectionView: UICollectionView {
    weak var mainCollectionViewDelegate: MainCollectionViewDelegate?
    
    // 기존 CollectionView의 DataSource를 대체하기 위한 RxCollectionViewDataSource
    let rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfMainCard>
    
    init(_ collectionViewLayout: UICollectionViewLayout) {
        self.rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMainCard>(
            configureCell: { _, _, _, _ in
                UICollectionViewCell()
            }, configureSupplementaryView: { _, _, _, _ in
                UICollectionReusableView()
            }
        )
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        // 생성 시 `UICollectionViewFlowLayout` 일 경우 기본 레이아웃 설정
        let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.minimumLineSpacing = 4
        collectionViewLayout?.minimumInteritemSpacing = 0
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
                
        setup()
        configureDataSoruce()
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
    
    private func configureDataSoruce() {
        rxDataSource.configureCell = { [weak self] _, collectionView, indexPath, cardInfo in
            guard let self = self else { return UICollectionViewCell() }
            
            let cell: MainCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: cardInfo)
            cell.navigationToDetailsButton.rx.tap
                .subscribe { _ in
                        self.mainCollectionViewDelegate?.goToDetails(indexPath)
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
        
        rxDataSource.configureSupplementaryView = { dataSource, collectionView, _, indexPath in
            let header: MainCollectionHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            header.configure(with: dataSource.sectionModels[indexPath.section].model)
            return header
        }
    }
}
