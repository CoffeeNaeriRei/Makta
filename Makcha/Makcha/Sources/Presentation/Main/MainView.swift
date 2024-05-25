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
    private let cellTemplate = MainCollectionCell()
    private let headerCellTemplate = MainCollectionHeaderCell()
    var collectionViewLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView
    
    init() {
        collectionView = MainCollectionView(collectionViewLayout)
        super.init(frame: .zero)
        layout()

        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.pin.top(pin.safeArea)
            .horizontally().vertically(185)
    }
    
    private func setupCollectionView() {
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.sectionHeadersPinToVisibleBounds = true
        
        collectionView.delegate = self
        collectionView.register(cellType: MainCollectionCell.self)
        collectionView.register(supplementaryViewType: MainCollectionHeaderCell.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
    }
    
    private func layout() {
        setupCollectionView()
        
        currentTimeLabel.attributedText = .pretendard("오늘의 시간", scale: .title)
        currentPathCountLabel.attributedText = .pretendard("갯수", scale: .headline)
        rootView.flex.gap(.cfSpacing(.large)).define {
            $0.addItem().direction(.column).define {
                $0.direction(.row).define {
                    $0.addItem(currentTimeLabel).grow(1)
                    $0.addItem(currentPathCountLabel).grow(1)
                }
            }
            .padding(.cfSpacing(.large))
        }
        .border(1, .red)
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
