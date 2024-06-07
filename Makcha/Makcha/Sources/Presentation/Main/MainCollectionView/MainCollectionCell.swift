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
import RxSwift

final class MainCollectionCell: UICollectionViewCell, Reusable {
    private let pathTypelabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard(
            "경로 종류",
            scale: .body,
            weight: .semiBold
        )
        label.textColor = UIColor.cf(.colorScale(.blue(.mediumLight)))
        
        return label
    }()
    
    private let estimatedTimeOfArrivalLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard("도착 예정 시간", scale: .caption)
        label.textColor = UIColor.cf(.grayScale(.gray600))
        
        return label
    }()
    
    private let durationTimeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard("NN:NN", scale: .title)
        label.textColor = UIColor.cf(.grayScale(.gray800))
        
        return label
    }()
    
    // 자세히 보기 버튼: 생성 버튼과정이 길어서, 추후 Factory 패턴으로 코드 분리할 예정
    let navigationToDetailsButton: UIButton = {
        let button = UIButton()
        
        let tintColor = UIColor.cf(.grayScale(.gray800))
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
        let textColor = UIColor.cf(.grayScale(.black))
        
        label.attributedText = .pretendard("NN분\n NN초", scale: .display)
        label.textColor = textColor
        
        return label
    }()
    
    // MARK: 다음 도착 예정인 교통수단이 정거장에 도착하기 까지 남은 시간을 표시하는 라벨
    private let nextArrivalTransportTimeLabel: UILabel = {
        let label = UILabel()
        let textColor = UIColor.cf(.grayScale(.gray500))
        
        label.attributedText = .pretendard("다음 도착 NN분 예정", scale: .body)
        label.textColor = textColor
        
        return label
    }()
    
    private let centerContentsTopLabel: UILabel = {
        let label = UILabel()
        let textColor = UIColor.cf(.grayScale(.gray600))
        label.attributedText = .pretendard("도착 예정", scale: .caption)
        label.textColor = textColor
        
        return label
    }()
    
    private let pathScrollView = UIScrollView()
    private let pathsContentView = ContentView()
    private let centerContentsTopContainer = UIView()
    private let nextArrivalTransportTimeContainer = UIView()
    
    var disposeBag = DisposeBag()
    
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
                $0.addItem(centerContentsTopContainer).define {
                    $0.addItem(centerContentsTopLabel)
                }
                $0.addItem(currentArrivalTransportTimeLabel)
                $0.addItem(nextArrivalTransportTimeContainer).define {
                    $0.addItem(nextArrivalTransportTimeLabel)
                }
            }
            .position(.absolute).top(64)
            
            /// BottomContents
            $0.addItem().define {
                let startColor = UIColor.cf(.grayScale(.white))
                let endColor = UIColor.cf(.grayScale(.white)).withAlphaComponent(0)
                let leftGradientView = GradientView()
                leftGradientView.setGradientColors([startColor, endColor])
                leftGradientView.setGradientDirection(
                    startPoint: .init(x: 0, y: 0),
                    endPoint: .init(x: 1, y: 0)
                )

                let rightGradientView = GradientView()
                rightGradientView.setGradientColors([startColor, endColor])
                rightGradientView.setGradientDirection(
                    startPoint: .init(x: 1, y: 0),
                    endPoint: .init(x: 0, y: 0)
                )
                
                $0.addItem(pathScrollView).direction(.row).define {
                    $0.addItem(pathsContentView)
                }
                .minHeight(66)
                .marginBottom(12)
//                .border(1, .red)
                // Fade Effect
                $0.addItem(leftGradientView)
                    .position(.absolute)
                    .width(24).height(66)
                $0.addItem(rightGradientView)
                    .position(.absolute)
                    .width(24).height(66)
                    .right(0)
            }
                .width(100%)
                .position(.absolute).bottom(0)
            
            /// BottomLine
            $0.addItem()
                .width(100%).height(.cfStroke(.xsmall))
                .backgroundColor(.cf(.grayScale(.gray200)))
        }
        .backgroundColor(.cf(.grayScale(.white)))
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pathScrollView.setContentOffset(.zero, animated: false)
        disposeBag = DisposeBag()
    }
}

private final class ContentView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout(mode: .adjustHeight)
        if let scrollView = superview as? UIScrollView {
            scrollView.contentSize = frame.size
        }
    }
}

extension MainCollectionCell {
    // MARK: 패치 된 데이터를 활용해 뷰 레이아웃을 설정하기 위한 인터페이스 메서드
    func configure(with data: MakchaCellData) {
        estimatedTimeOfArrivalLabel.text = data.makchaPath.arrivalTime.endPointTimeString
        estimatedTimeOfArrivalLabel.flex.markDirty()

        let totalTimeDescription = calcTotalTimeDescription(data.makchaPath.totalTime)
        let totalTimeText = NSMutableAttributedString.pretendard(totalTimeDescription.text, scale: .title)
        
        if let hourIdx = totalTimeDescription.idx.first, let hourIdx = hourIdx {
            totalTimeText.addAttributes(
                [
                    .font : UIFont.pretendard(.medium, size: 12),
                    .foregroundColor: UIColor.cf(.grayScale(.gray600))
                ],
                range: .init(location: hourIdx, length: 2)
            )
        }
        
        if let minuteIdx = totalTimeDescription.idx.last, let minuteIdx = minuteIdx {
            if let hourIdx = totalTimeDescription.idx.first, let hourIdx = hourIdx {
                totalTimeText.addAttributes(
                    [
                        .font : UIFont.pretendard(.medium, size: 12),
                        .foregroundColor: UIColor.cf(.grayScale(.gray600))
                    ],
                    range: .init(location: hourIdx + 2 + minuteIdx, length: 1)
                )
            } else {
                totalTimeText.addAttributes(
                    [
                        .font : UIFont.pretendard(.medium, size: 12),
                        .foregroundColor: UIColor.cf(.grayScale(.gray600))
                    ],
                    range: .init(location: minuteIdx, length: 1)
                )
            }
        }

        durationTimeLabel.attributedText = totalTimeText
        durationTimeLabel.flex.markDirty()

        centerContentsTopContainer.subviews.forEach { $0.removeFromSuperview() }
        centerContentsTopContainer.flex.direction(.row).define {
            let firstTransport = data.makchaPath.subPath
                .filter { $0.subPathType != .walk }
                .first
            
            if firstTransport?.subPathType == .bus, let busInfo = firstTransport?.lane?.first {
                let busColor: UIColor = busInfo.busRouteType?.busUIColor ?? .clear
                let busNoLabel = UILabel()
                busNoLabel.attributedText = .pretendard(busInfo.name, scale: .caption2)
                busNoLabel.textAlignment = .center
                busNoLabel.textColor = busColor

                $0.addItem(centerContentsTopLabel)
                    .marginLeft(busNoLabel.intrinsicContentSize.width + 12)
                $0.addItem(busNoLabel)
                    .marginLeft(4)
                    .padding(2, 4)
                    .border(1, busColor)
                    .cornerRadius(2)
            } else {
                $0.addItem(centerContentsTopLabel)
            }
        }
        centerContentsTopContainer.flex.markDirty()
        
        currentArrivalTransportTimeLabel.text = data.arrival.first.arrivalMessage
        currentArrivalTransportTimeLabel.flex.markDirty()
        
        nextArrivalTransportTimeLabel.text = data.arrival.second.arrivalMessage
        nextArrivalTransportTimeLabel.flex.markDirty()

        pathsContentView.subviews.forEach { $0.removeFromSuperview() }
        pathsContentView.flex.direction(.row).define {
            $0.addItem(layoutPathInfo(with: data.makchaPath.subPath))
        }
        .paddingHorizontal(24)
        pathsContentView.flex.markDirty()
        
        setNeedsLayout()
    }
    
    private func calcTotalTimeDescription(_ totalTime: Int) -> (text: String, idx: [Int?]) {
        let hour = totalTime / 60
        let minute = totalTime - hour * 60
        
        let hourDescription = hour > 0 ? "\(hour)시간" : ""
        let minuteDescription = minute > 0 ? "\(minute)분" : ""

        let hourIdx = hourDescription.isEmpty ? nil : hourDescription.count - 2
        let minuteIdx = minuteDescription.isEmpty ? nil : minuteDescription.count - 1
        
        return (
            hourDescription + minuteDescription,
            [hourIdx, minuteIdx]
        )
    }
    
    // MARK: 들어오는 경로 데이터에 따라 다르게 뷰를 그리기 위한 메서드
    private func layoutPathInfo(with subPaths:[MakchaSubPath]) -> UIView {
        let rootView = UIView()
        let totalDistance = subPaths.map { CGFloat($0.distance) }.reduce(0) { $0 + $1 }
        rootView.flex.direction(.row).define {
            for subPath in subPaths {
                let isLastPath = subPath.idx == subPaths.count - 1
                var distanceForUI = CGFloat(subPath.distance) / totalDistance * UIScreen.main.bounds.width * 1.25
                if distanceForUI < 24 {
                    distanceForUI = 24
                }
                
                let subPathType = subPath.subPathType
                
                let label = UILabel()
                label.text = subPathType.rawValue
                
                let symbolConfig = UIImage.SymbolConfiguration(
                    pointSize: 14,
                    weight: .regular,
                    scale: .default
                )
                let icon = UIImage(
                    systemName: isLastPath ? "house.fill" : subPathType.iconName,
                    withConfiguration: symbolConfig
                )
                switch subPathType {
                case .walk:
                    let bgColor = UIColor.cf(.grayScale(.gray500))
                    let iconTintColor = UIColor.cf(.grayScale(.gray300))
                    let iconBgColor = UIColor.cf(.grayScale(.gray50))
                    let iconBorderColor = UIColor.cf(.grayScale(.white))

                    $0.addItem().direction(.row).alignItems(.end).define {
                        $0.addItem()
                            .width(isLastPath ?
                                   CGFloat(distanceForUI - 12) :
                                    CGFloat(distanceForUI - 12)).height(10)
                            .backgroundColor(bgColor)
                            .cornerRadius(5)
                            .marginBottom(7)
                            .marginLeft(isLastPath ? 0 : 12)
                            .marginRight(isLastPath ? 12 : 0)
                        $0.addItem().position(.absolute).define {
                            let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode: .alwaysOriginal))
                            imageView.contentMode = .center
                            $0.addItem(imageView)
                                .width(24).height(24)
                                .backgroundColor(iconBgColor)
                                .border(1, iconBorderColor)
                                .cornerRadius(12)
                        }
                        .left(isLastPath ? CGFloat(distanceForUI - 24) : 0)
//                        .border(1, .red)
                    }
                    .minWidth(24)
                case .bus:
                    // 첫번째 버스로부터 색상정보 가져오도록 함
                    guard let busType = subPath.lane?.first?.busRouteType else { return }
                    let bgColor = busType.busUIColor
                    let distanceBgColor = UIColor(busType.busColor.opacity(0.6))
                    let iconTintColor = UIColor.cf(.grayScale(.white))
                    
                    let stationName = subPath.stations?.first?.name ?? "Undefined"
                    print(stationName)
                    let time = "+\(subPath.time)분"
                    
                    $0.addItem().direction(.row).alignItems(.end).define {
                        $0.addItem()
                            .width(distanceForUI).height(10)
                            .backgroundColor(distanceBgColor)
                            .cornerRadius(5)
                            .marginBottom(7)
                            .marginLeft(12)
                            .marginRight(0)
                        $0.addItem().position(.absolute).define {
                            let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
                            imageView.contentMode = .center
                            
                            let textContainerView = UIView()
                            let arrivalStationLabel = UILabel()
                            arrivalStationLabel.attributedText = .pretendard(stationName, scale: .body)
                            arrivalStationLabel.textColor = .cf(.grayScale(.gray800))
                            arrivalStationLabel.textAlignment = .center
                            arrivalStationLabel.lineBreakMode = .byTruncatingTail
                            arrivalStationLabel.numberOfLines = 1
                            
                            let arriveTimeLabel = UILabel()
                            arriveTimeLabel.attributedText = .pretendard(time, scale: .caption)
                            arriveTimeLabel.textColor = .cf(.grayScale(.gray600))
                            arriveTimeLabel.textAlignment = .center
                            // TextContainer
                            
                            var textContainerWidth: CGFloat = .zero
                            let arrivalStationContainer = UIView()
                            
                            $0.addItem(textContainerView).position(.absolute).define {
                                $0.addItem(arriveTimeLabel)
//                                    .border(2, .red)
                                    .width(100%)
                                $0.addItem(arrivalStationContainer).direction(.row).define {
                                    $0.addItem(arrivalStationLabel)
                                        .maxWidth(80)
                                    guard let lane = subPath.lane else { return }
                                    
                                    for lan in lane {
                                        let transportLabel = UILabel()
                                        transportLabel.attributedText = .pretendard(lan.name, scale: .caption2)
                                        transportLabel.textAlignment = .center
                                        transportLabel.textColor = bgColor

                                        $0.addItem(transportLabel)
                                            .border(1, bgColor)
                                            .padding(.cfRadius(.xxxsmall))
                                            .cornerRadius(.cfRadius(.xxxsmall))
                                            .marginLeft(4)
                                    }
                                }
                                
                                textContainerWidth = arrivalStationLabel.intrinsicContentSize.width
                                
                                if textContainerWidth > 80 {
                                    textContainerWidth = 80
                                }
                                
                                $0.width(textContainerWidth)
                            }
                            .left(-(textContainerWidth / 2) + 12)
                            .bottom(24)
                            // IconContainer
                            $0.addItem().define {
                                $0.addItem(imageView)
                                    .width(24).height(24)
                                    .backgroundColor(bgColor)
                                    .border(1, .white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                case .subway:
                    // 첫번째 버스로부터 색상정보 가져오도록 함
                    guard let subwayType = subPath.lane?.first?.subwayCode else { return }
                    let bgColor = subwayType.subWayUIColor
                    let distanceBgColor = UIColor(subwayType.subwayColor.opacity(0.6))
                    let iconTintColor = UIColor.cf(.grayScale(.white))
                    let stationName = "\(subPath.stations?.first?.name ?? "undefined")역"
                    let time = "+\(subPath.time)분"
                    
                    $0.addItem().direction(.row).alignItems(.end).define {
                        $0.addItem()
                            .width(distanceForUI).height(10)
                            .backgroundColor(distanceBgColor)
                            .cornerRadius(5)
                            .marginBottom(7)
                            .marginLeft(12)
                            .marginRight(0)
                        $0.addItem().position(.absolute).define {
                            let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
                            imageView.contentMode = .center
                            
                            let textContainerView = UIView()
                            let arrivalStationLabel = UILabel()
                            arrivalStationLabel.attributedText = .pretendard(stationName, scale: .body)
                            arrivalStationLabel.textColor = .cf(.grayScale(.gray800))
                            arrivalStationLabel.textAlignment = .center

                            let arriveTimeLabel = UILabel()
                            arriveTimeLabel.attributedText = .pretendard(time, scale: .caption)
                            arriveTimeLabel.textColor = .cf(.grayScale(.gray600))
                            arriveTimeLabel.textAlignment = .center
                            // TextContainer
                            
                            var textContainerWidth: CGFloat = .zero
                            let arrivalStationContainer = UIView()
                            
                            $0.addItem(textContainerView).position(.absolute).define {
                                $0.addItem(arriveTimeLabel)
//                                    .border(2, .red)
                                    .width(100%)
                                $0.addItem(arrivalStationContainer).define {
                                    $0.addItem(arrivalStationLabel)
//                                        .border(1, .red)
                                        .width(100%)
                                }
                                .width(100%)
                                textContainerWidth = arrivalStationContainer.subviews
                                    .map { $0.intrinsicContentSize.width }
                                    .reduce(0) { $0 + $1 }
                            }
                            .left(-(textContainerWidth / 2) + 12)
                            .bottom(24)
                            // IconContainer
                            $0.addItem().define {
                                $0.addItem(imageView)
                                    .width(24).height(24)
                                    .backgroundColor(bgColor)
                                    .border(1, .white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            
        }
        .minHeight(66)
        .marginBottom(12)
//        .border(1, .red)
        
        return rootView
    }
}

#if DEBUG
struct MainCollectionCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = MainCollectionCell()
        let data: MakchaCellData = (mockMakchaInfo.makchaPaths.last!, (ArrivalStatus.arriveSoon, ArrivalStatus.arriveSoon))
        ViewPreview {
            cell.configure(with: data)
            return cell
        }
    }
}
#endif
