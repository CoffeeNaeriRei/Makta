//
//  DetailView.swift
//  Makcha
//
//  Created by yuncoffee on 6/8/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import FlexLayout
import PinLayout

final class DetailView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let pathTypelabel = UILabelFactory.build(
        attributedText: .pretendard("경로 종류", scale: .body, weight: .semiBold),
        textColor: .cf(.colorScale(.blue(.mediumLight)))
    )
    
    private let estimatedTimeOfArrivalLabel = UILabelFactory.build(
        attributedText: .pretendard("도착 예정 시간", scale: .caption),
        textColor: .cf(.grayScale(.gray600))
    )
    
    private let durationTimeLabel = UILabelFactory.build(
        attributedText: .pretendard("NN:NN", scale: .title),
        textAlignment: .left,
        textColor: .cf(.grayScale(.gray800))
    )
    
    // MARK: 현재 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    private let currentArrivalTransportTimeLabel = UILabelFactory.build(
        attributedText: .pretendard("NN분\n NN초", scale: .display),
        textColor: .cf(.grayScale(.black))
    )
    
    // MARK: 다음 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    private let nextArrivalTransportTimeLabel = UILabelFactory.build(
        text: "다음 도착 NN분 예정",
        textColor: .cf(.grayScale(.gray500))
    )
    
    private let centerContentsTopLabel = UILabelFactory.build(
        attributedText: .pretendard("도착 예정", scale: .caption),
        textColor: .cf(.grayScale(.gray600))
    )

    private let centerContentsTopContainer = UIView()
    private let nextArrivalTransportTimeContainer = UIView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .cf(.grayScale(.white))
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        contentView.flex.define {
            // TopContents
            $0.addItem().define {
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
                }
                .grow(1)
                /// CenterContents
                $0.addItem().alignItems(.center).alignSelf(.center).define {
                    $0.addItem(centerContentsTopContainer).define {
                        $0.addItem(centerContentsTopLabel)
                    }
                    $0.addItem(currentArrivalTransportTimeLabel)
                    $0.addItem(nextArrivalTransportTimeContainer).define {
                        $0.addItem(nextArrivalTransportTimeLabel)
                    }
                }
                .position(.absolute).top(64)
                /// BottomLine
                $0.addItem()
                    .width(100%).height(.cfStroke(.xsmall))
                    .backgroundColor(.cf(.grayScale(.gray200)))
            }
            .backgroundColor(.cf(.grayScale(.white)))
            .border(1, .green)
            .height(160)
            for _ in 0...20 {
                $0.addItem()
                    .height(120)
                    .border(1, .red)
            }
        }
        .border(1, .blue)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.all(pin.safeArea)
        scrollView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
}

extension DetailView {
    func configure(data: MakchaCellData) {
        
    }
}

struct DetailView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            DetailView()
        }
    }
}
