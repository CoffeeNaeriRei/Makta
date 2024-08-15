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

protocol DetailViewDelegate: AnyObject {
    func didSubPathViewHeightChange()
}

final class DetailView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let subPathContainer = UIView()
    
    private let pathTypelabel = UILabelFactory.build(
        attributedText: .pretendard("경로 종류", scale: .body, weight: .semiBold),
        textColor: .cf(.colorScale(.blue(.mediumLight)))
    )
    
    private let estimatedTimeOfArrivalLabel = UILabelFactory.build(
        attributedText: .pretendard("도착 예정 시간", scale: .caption),
        textColor: .cf(.grayScale(.gray600))
    )
    
    let durationTimeLabel = UILabelFactory.build(
        attributedText: .pretendard("불러오는 중...", scale: .title), // NN:NN
        textAlignment: .left,
        textColor: .cf(.grayScale(.gray800))
    )
    
    // MARK: 현재 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    let currentArrivalTransportTimeLabel = {
        let label = UILabelFactory.build(
            attributedText: .pretendard("불러오는 중...", scale: .display), // NN분 NN초
            textColor: .cf(.grayScale(.black)))
        
        label.attributedText = .repet("불러오는 중...", size: 36, alt: .bold)
        
        return label
    }()
    
    // MARK: 다음 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    let nextArrivalTransportTimeLabel = {
       let label = UILabelFactory.build(
            text: "불러오는 중...", // 다음 도착 NN분 예정
            textColor: .cf(.grayScale(.gray600))
        )
        
        label.attributedText = .repet("불러오는 중...", size: 14)
        
        return label
    }()
    
    private let centerContentsTopLabel = UILabelFactory.build(
        attributedText: .pretendard("도착 예정", scale: .caption),
        textColor: .cf(.grayScale(.gray600))
    )
    
    private let centerContentsTopContainer = UIView()
    private let nextArrivalTransportTimeContainer = UIView()
    
    private let startPointLabel = UILabelFactory.build(
        attributedText: .pretendard("출발지", scale: .headline),
        textAlignment: .left,
        textColor: .cf(.grayScale(.gray900))
    )
    private let endPointLabel = UILabelFactory.build(
        attributedText: .pretendard("도착지", scale: .headline),
        textAlignment: .left,
        textColor: .cf(.grayScale(.gray900))
    )
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .background
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
                        .width(100%)
                        .marginTop(12)
                    $0.addItem(nextArrivalTransportTimeLabel)
                        .width(100%)
                        .marginTop(4)
                    .width(100%)
                }
                .width(100%)
                .position(.absolute).top(64)
                .width(100%)
            }
            .backgroundColor(.background)
            .height(160)
            /// 상세 경로 정보
            let detailContainer = DottedLineView()
            detailContainer.lineColor = .cf(.grayScale(.gray400))
            detailContainer.lineWidth = 1
            detailContainer.position = .top
            
            $0.addItem().gap(2).define {
                let titleLabel = UILabelFactory.build(text: "경로 정보", textAlignment: .left)
                let startImageView = UIImageView()
                let endImageView = UIImageView()
                
                let symbolConfig = UIImage.SymbolConfiguration(
                    pointSize: 14,
                    weight: .regular,
                    scale: .default
                )
                
                let startIcon = UIImage(
                    systemName: "location.fill",
                    withConfiguration: symbolConfig
                )?.withTintColor(.cf(.grayScale(.gray600)), renderingMode: .alwaysOriginal)
                
                startImageView.image = startIcon
                startImageView.contentMode = .center
                startImageView.flex
                    .backgroundColor(.cf(.grayScale(.gray200)))
                    .border(1, .cf(.grayScale(.gray200)))
                
                let endIcon = UIImage(
                    systemName: "house.fill",
                    withConfiguration: symbolConfig
                )?.withTintColor(.cf(.grayScale(.gray600)), renderingMode: .alwaysOriginal)
                
                endImageView.image = endIcon
                endImageView.contentMode = .center
                endImageView.flex
                    .backgroundColor(.cf(.grayScale(.gray200)))
                    .border(1, .cf(.grayScale(.gray200)))
                
                // headerContainer
                $0.addItem(detailContainer).define {
                    $0.addItem(titleLabel)
                }
                .padding(16, 24, 12)
                // startLabel
                $0.addItem().direction(.row).gap(8).define {
                    $0.addItem(startImageView).width(24).height(24).cornerRadius(12)
                    $0.addItem(startPointLabel)
                }.marginLeft(32)
                // SubPathContainer
                $0.addItem(subPathContainer)
                // endLabel
                $0.addItem().direction(.row).gap(8).define {
                    $0.addItem(endImageView).width(24).height(24).cornerRadius(12)
                    $0.addItem(endPointLabel)
                }
                .marginLeft(32)
                .marginBottom(32)
            }
        }
        .backgroundColor(.subpathContainer)
        .grow(1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.top(pin.safeArea.top).horizontally().bottom()
        scrollView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
}

extension DetailView: DetailViewDelegate {
    func didSubPathViewHeightChange() {
        subPathContainer.flex.markDirty()
        scrollView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
    
    func configure(data: MakchaCellData, path: (String, String)) {
        let pathType = data.makchaPath.makchaPathType.rawValue
        pathTypelabel.text = data.makchaPath.fastest ? "\(pathType)(가장 빠른 경로)" : pathType
        pathTypelabel.flex.markDirty()
        
        estimatedTimeOfArrivalLabel.text = "\(data.makchaPath.arrivalTime.endPointTimeString) 도착"
        estimatedTimeOfArrivalLabel.flex.markDirty()
        
        // 막차 경로의 전체 소요시간을 그려줌
        layoutTotalDurationTimeLabel(totalTime: data.makchaPath.totalTime)
        
        startPointLabel.attributedText = .pretendard(path.0, scale: .headline)
        startPointLabel.flex.markDirty()
        
        endPointLabel.attributedText = .pretendard(path.1, scale: .headline)
        endPointLabel.flex.markDirty()
        
        subPathContainer.flex.define {
            $0.addItem()
            for subPath in data.makchaPath.subPath {
                let detailView = DetailSubPathView(
                    subPath: subPath,
                    totalTime: data.makchaPath.totalTime
                )
                detailView.delegate = self
                $0.addItem(detailView)
            }
            $0.addItem()
        }
        subPathContainer.flex.markDirty()
    }
}

extension DetailView {
    //TODO: - MainCollectionCell에 있는 layoutCenterContentsTopContainer와 거의 유사하기 때문에 메서드 하나로 정리 필요
    private func layoutTotalDurationTimeLabel(totalTime: Int) {
        // totalTime String 변환 ex) 72 -> 1시간12분
        let totalTimeDescription = totalTime.calcTotalTimeDescription()
        // 숫자와 시간/분 스타일 다르게 적용
        let totalTimeText = NSMutableAttributedString.repet(totalTimeDescription.text, size: 24)
        let customAttr: [NSAttributedString.Key: Any] = [
            .font : UIFont.pretendard(.medium, size: 12),
            .foregroundColor: UIColor.cf(.grayScale(.gray600))
        ]
        if let hourIdx = totalTimeDescription.idx.first, let hourIdx = hourIdx {
            let range: NSRange = .init(location: hourIdx, length: 2)
            totalTimeText.addAttributes(customAttr, range: range)
        }
        
        if let minuteIdx = totalTimeDescription.idx.last, let minuteIdx = minuteIdx {
            if let hourIdx = totalTimeDescription.idx.first, let hourIdx = hourIdx {
                let range: NSRange = .init(location: hourIdx + 2 + minuteIdx, length: 1)
                totalTimeText.addAttributes(customAttr, range: range)
            } else {
                let range: NSRange = .init(location: minuteIdx, length: 1)
                totalTimeText.addAttributes(customAttr, range: range)
            }
        }
        // 텍스트에 스타일 적용
        durationTimeLabel.attributedText = totalTimeText
        durationTimeLabel.flex.markDirty()
    }
}

#if DEBUG
struct DetailView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            let makchaPath = MakchaInfo.mockMakchaInfo.makchaPaths.last!
            let rtat: RealtimeArrivalTuple = (
                RealtimeArrivalInfo(status: .arriveSoon, way: nil, nextSt: nil),
                RealtimeArrivalInfo(status: .arriveSoon, way: nil, nextSt: nil)
            )
            let view = DetailView()
            view.configure(data: (makchaPath, (rtat)), path:("", ""))
            return view
        }
    }
}
#endif
