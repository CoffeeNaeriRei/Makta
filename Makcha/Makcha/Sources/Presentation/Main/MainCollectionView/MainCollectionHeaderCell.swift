//
//  MainCollectionHeaderCell.swift
//  Makcha
//
//  Created by yuncoffee on 5/25/24.
//

import Foundation
import UIKit
import PinLayout
import FlexLayout
import MakchaDesignSystem
import Reusable

final class MainCollectionHeaderCell: UICollectionViewCell, Reusable {
    
    private var cellHeight = 48.0
    
    private var startTimeLabel: UILabel {
        let label = UILabel()
        
        label.text = "출발 시간 출발"
        
        return label
    }
    
    private var resetButton: UIButton {
        let button = UIButton()
        button.setTitle("현재 위치로 재설정", for: .normal)
        button.configuration = .filled()
        
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.flex.direction(.row).alignItems(.center).define {
            $0.addItem(startTimeLabel)
                .grow(1)
            $0.addItem(resetButton)
        }
        .padding(0, 16, 0, 8)
        .minHeight(cellHeight)
        .border(1, .red)
    }
    
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        
        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
}

extension MainCollectionHeaderCell {
    func configure(startTile: String) {
        setNeedsLayout()
    }
}

#if DEBUG
import SwiftUI
struct MainCollectionHeaderCell_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            MainCollectionHeaderCell()
        }
    }
}
#endif
