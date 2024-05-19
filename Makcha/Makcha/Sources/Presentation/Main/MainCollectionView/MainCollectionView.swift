//
//  MainCollectionView.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

import Foundation
import UIKit

final class MainCollectionView: UICollectionView {
    init(_ collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: .zero,
                   collectionViewLayout: collectionViewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
