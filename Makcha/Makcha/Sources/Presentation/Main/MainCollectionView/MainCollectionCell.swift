//
//  MainCollectionCell.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import FlexLayout
import PinLayout
import Reusable

final class MainCollectionCell: UICollectionViewCell, Reusable {
    private let pathTypelabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard(
            "경로 종류", 
            scale: .body,
            weight: .semiBold
        )
        label.textColor = UIColor(Color.cf(.colorScale(.blue(.mediumLight))))
        
        return label
    }()
    
    private let estimatedTimeOfArrivalLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard("도착 예정 시간", scale: .caption)
        label.textColor = UIColor(Color.cf(.grayScale(.gray600)))
        
        return label
    }()
    
    private let durationTimeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard("NN:NN", scale: .title)
        label.textColor = UIColor(Color.cf(.grayScale(.gray800)))
        
        return label
    }()
    
    // 자세히 보기 버튼: 생성 버튼과정이 길어서, 추후 Factory 패턴으로 코드 분리할 예정
    private let navigationToDetailsButton: UIButton = {
        let button = UIButton()
        
        let tintColor = UIColor(Color.cf(.grayScale(.gray800)))
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .regular,
            scale: .default
        )
        
        let icon = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)?
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)
        var titleAttr = AttributedString("자세히 보기")
        titleAttr.font = UIFont.pretendard(.medium, size: 14)
        
        var buttonConfig: UIButton.Configuration = .plain()
        buttonConfig.imagePadding = 4
        buttonConfig.attributedTitle = titleAttr
        buttonConfig.contentInsets = .zero
        
        button.configuration = buttonConfig
        
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = tintColor
        button.semanticContentAttribute = .forceRightToLeft
        button.flex.paddingHorizontal(.cfSpacing(.medium)).minHeight(40)
        
        return button
    }()
    
    // MARK: 현재 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    private let currentArrivalTransportTimeLabel: UILabel = {
        let label = UILabel()
        let textColor = UIColor(Color.cf(.grayScale(.black)))
        
        label.attributedText = .pretendard("NN분\n NN초", scale: .display)
        label.textColor = textColor
        
        return label
    }()

    // MARK: 다음 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    private let nextArrivalTransportTimeLabel: UILabel = {
        let label = UILabel()
        let textColor = UIColor(Color.cf(.grayScale(.gray500)))
        
        label.attributedText = .pretendard("다음 도착 NN분 예정", scale: .body)
        label.textColor = textColor
        
        return label
    }()
    
    private let centerContentsTopLabel: UILabel = {
        let label = UILabel()
        let textColor = UIColor(Color.cf(.grayScale(.gray600)))
        label.attributedText = .pretendard("도착 예정", scale: .caption)
        label.textColor = textColor
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.flex.define {
            /// TopContents
            $0.addItem().direction(.row).alignItems(.start).define {
                $0.addItem().justifyContent(.spaceBetween).define {
                    $0.addItem()
                        .direction(.row).alignItems(.center)
                        .gap(.cfSpacing(.xsmall)).define {
                            $0.addItem().define {
                                $0.addItem(pathTypelabel)
                            }
                            $0.addItem(estimatedTimeOfArrivalLabel)
                        }
                    $0.addItem(durationTimeLabel)
                }
                .grow(1)
                .paddingTop(.cfSpacing(.xlarge))
                .paddingLeft(.cfSpacing(.xxxlarge))
                $0.addItem(navigationToDetailsButton)
                    .marginTop(5)
            }
            .grow(1)
            
            /// CenterContents
            $0.addItem().alignItems(.center).alignSelf(.center).define {
                $0.addItem(centerContentsTopLabel)
                $0.addItem(currentArrivalTransportTimeLabel)
                $0.addItem(nextArrivalTransportTimeLabel)
            }
            .position(.absolute).top(64)
            
            /// BottomContents
            $0.addItem(layoutPathInfo())
                .width(100%)
                .position(.absolute).bottom(0)
                
            /// BottomLine
            $0.addItem()
                .width(100%).height(.cfStroke(.xsmall))
                .backgroundColor(UIColor(Color.cf(.grayScale(.gray200))))
        }
        .backgroundColor(UIColor(Color.cf(.grayScale(.white))))
        .height(240)
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

extension MainCollectionCell {
    // MARK: 패치 된 데이터를 활용해 뷰 레이아웃을 설정하기 위한 인터페이스 메서드
    func configure(with data: MakchaCellData) {
        
        estimatedTimeOfArrivalLabel.text = data.makchaPath.arrivalTime.description
        estimatedTimeOfArrivalLabel.flex.markDirty()
        
        durationTimeLabel.text = data.makchaPath.totalTime.description
        durationTimeLabel.flex.markDirty()
        
        currentArrivalTransportTimeLabel.text = data.arrival.first.arrivalMessage
        currentArrivalTransportTimeLabel.flex.markDirty()
        
        nextArrivalTransportTimeLabel.text = data.arrival.second.arrivalMessage
        nextArrivalTransportTimeLabel.flex.markDirty()
        
        setNeedsLayout()
    }
    
    // MARK: 들어오는 경로 데이터에 따라 다르게 뷰를 그리기 위한 메서드
    func layoutPathInfo() -> UIView {
        let rootView = UIView()
        
        rootView.flex.define {
            $0.addItem()
        }
        .minHeight(66)
        .marginBottom(12)
        .border(1, .red)
        
        return rootView
    }
}

#if DEBUG
struct MainCollectionCell_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            MainCollectionCell()
        }
    }
}
#endif
