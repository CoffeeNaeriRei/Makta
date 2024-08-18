//
//  MainCollectionHeaderCell.swift
//  Makcha
//
//  Created by yuncoffee on 5/25/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import PinLayout
import FlexLayout
import RxSwift

final class MainCollectionHeaderCell: UICollectionViewCell {
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString.pretendard("출발 시간 출발", scale: .headline)

        label.textColor = UIColor.cf(.grayScale(.gray800))
        label.attributedText = text
        
        return label
    }()
    
    // MARK: rxSwift를 활용해 바인딩하기 위해 인터널 선언
    let resetButton: UIButton = {
        let button = UIButton()
        
        let tintColor = UIColor.cf(.grayScale(.gray700))
        let borderColor = UIColor.cf(.grayScale(.gray400))
        let text = NSMutableAttributedString.pretendard("현재 위치로 재설정", scale: .caption)

        var buttonConfig: UIButton.Configuration = .plain()
        buttonConfig.contentInsets = .zero
        
        button.configuration = buttonConfig
        button.setAttributedTitle(text, for: .normal)
        button.tintColor = tintColor

        button.flex.paddingHorizontal(.cfSpacing(.medium))
            .minHeight(28)
            .backgroundColor(.clear)
            .border(.cfStroke(.xsmall), borderColor)
            .cornerRadius(14)
        
        return button
    }()
    
    let addPathButton: UIButton = {
        let button = UIButton()
        
        let tintColor = UIColor.cf(.grayScale(.white))
        let text = NSMutableAttributedString.pretendard("경로 더보기", scale: .headline)
        
        var buttonConfig: UIButton.Configuration = .plain()
        buttonConfig.contentInsets = .zero
        
        button.configuration = buttonConfig
        button.setAttributedTitle(text, for: .normal)
        button.tintColor = tintColor
        
        button.flex.paddingHorizontal(.cfSpacing(.medium))
            .minHeight(48)
            .backgroundColor(.cf(.grayScale(.black)))
            .cornerRadius(24)
        
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
    func configurePlus() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.flex.backgroundColor(.clear)
        contentView.flex.padding(0, 0, 0, 0)

        UIView.animate(withDuration: 0.5) {
            self.contentView.flex.justifyContent(.center).alignItems(.center).define {
                $0.addItem(self.addPathButton)
                    .width(200)
            }
            .minHeight(48)
        }
        
        setNeedsLayout()
    }
    
    // MARK: 패치 된 데이터를 활용해 뷰 레이아웃을 설정하기 위한 인터페이스 메서드
    func configure(with startTime: String) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .init(width: 0, height: 4.0)
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOpacity = 0.05
        
        contentView.flex.backgroundColor(.background)
        contentView.flex.direction(.row).alignItems(.center).define {
            $0.addItem(startTimeLabel)
                .grow(1)
            $0.addItem(resetButton)
        }
        .padding(0, 16, 0, 8)
        .minHeight(48)
        
        let text = NSMutableAttributedString.pretendard("\(startTime) 출발", scale: .headline)
        text.addAttributes(
            [
                .foregroundColor : UIColor.cf(.colorScale(.royalBlue(.mediumLight)))
            ],
            range: .init(location: 0, length: startTime.count)
        )

        startTimeLabel.attributedText = text
        startTimeLabel.flex.markDirty()
        
        setNeedsLayout()
    }
}

#if DEBUG
struct MainCollectionHeaderCell_Preview: PreviewProvider {
    static var previews: some View {
        let view = MainCollectionHeaderCell()
        
        ViewPreview {
            view.configurePlus()
            return view
        }
    }
}
#endif
