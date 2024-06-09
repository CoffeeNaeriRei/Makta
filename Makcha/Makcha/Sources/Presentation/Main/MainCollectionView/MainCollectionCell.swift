//
//  MainCollectionCell.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

// swiftlint: disable file_length
import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import FlexLayout
import PinLayout
import Reusable
import RxSwift

final class MainCollectionCell: UICollectionViewCell, Reusable {
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
        textColor: .cf(.grayScale(.gray800))
    )
    
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
                let pathContentsHeight: CGFloat = 66
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
                .minHeight(pathContentsHeight)
                .marginBottom(12)
                $0.addItem(leftGradientView)
                    .position(.absolute)
                    .width(24).height(pathContentsHeight)
                $0.addItem(rightGradientView)
                    .position(.absolute)
                    .width(24).height(pathContentsHeight)
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
        // 상단 시간정보 업데이트
        layoutTopContentsContainer(data.makchaPath.arrivalTime.endPointTimeString)
        // 도착 예정 시간 레이아웃 업데이트
        layoutCenterContentsTopContainer(
            totalTime: data.makchaPath.totalTime,
            firstSubPath: data.makchaPath.subPath.filter { $0.subPathType != .walk }.first
        )
        // 타이머 도착 예정 시간 업데이트
        currentArrivalTransportTimeLabel.text = data.arrival.first.arrivalMessage
        currentArrivalTransportTimeLabel.flex.markDirty()
        nextArrivalTransportTimeLabel.text = data.arrival.second.arrivalMessage
        nextArrivalTransportTimeLabel.flex.markDirty()
        // 경로 업데이트
        layoutPathContentContainer(subPaths: data.makchaPath.subPath)
        // 레이아웃 갱신
        setNeedsLayout()
    }
    
    // MARK: 시간 분을 쪼개서 그리기 편하게 하기 위한 메서드 추후 분리될 수 있음
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
        // 1. 경로의 전체 길이를 구한다.
        let totalDistance = subPaths.map { CGFloat($0.distance) }.reduce(0) { $0 + $1 }
        
        rootView.flex.direction(.row).define {
            for subPath in subPaths {
                let isLastPath = subPath.idx == subPaths.count - 1
                // 2. (패스 길이 / 전체 길이 == 패스비율) * (스크린 사이즈 * 1.25) or 24(최소 아이콘 사이즈 길이 보장)
                // 패스 길이 비율에 따라 뷰를 그린다. -> 전체적인 뷰의 비율 보장
                let distanceForUI = max(CGFloat(subPath.distance) / totalDistance * UIScreen.main.bounds.width * 1.25, 24)
                let subPathType = subPath.subPathType
                
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
                    layoutPathInfoWalk($0, params: (isLastPath, distanceForUI, icon))
                case .bus:
                    // 첫번째 버스로부터 색상정보 가져오도록 함
                    guard let busType = subPath.lane?.first?.busRouteType else { return }
                    layoutPathInfoBus($0, params: ((isLastPath, distanceForUI, icon), busType, subPath))
                case .subway:
                    // 첫번째 지하철로부터 색상정보 가져오도록 함
                    guard let subwayType = subPath.lane?.first?.subwayCode else { return }
                    layoutPathInfoSubway($0, params: ((isLastPath, distanceForUI, icon), subwayType, subPath))
                }
            }
            
        }
        .minHeight(66)
        .marginBottom(12)
        
        return rootView
    }
}

// MARK: 하위 뷰 작성하는 코드가 길어져서 분리
extension MainCollectionCell {
    private func layoutTopContentsContainer(_ text: String) {
        estimatedTimeOfArrivalLabel.text = text
        estimatedTimeOfArrivalLabel.flex.markDirty()
    }
    
    private func layoutCenterContentsTopContainer(totalTime: Int, firstSubPath: MakchaSubPath?) {
        // totalTime String 변환 ex) 72 -> 1시간12분
        let totalTimeDescription = calcTotalTimeDescription(totalTime)
        // 숫자와 시간/분 스타일 다르게 적용
        let totalTimeText = NSMutableAttributedString.pretendard(totalTimeDescription.text, scale: .title)
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
        
        // 컨테이너 내 모든 자식 뷰 제거
        centerContentsTopContainer.subviews.forEach { $0.removeFromSuperview() }
        // 컨테이너 뷰 새로 그리기
        centerContentsTopContainer.flex.direction(.row).define {
            if firstSubPath?.subPathType == .bus,
                let busInfo = firstSubPath?.lane?.first,
               let busColor = busInfo.busRouteType?.busUIColor {
                
                let busNoLabel = UILabelFactory.build(
                    text: busInfo.name,
                    textScale: .caption2,
                    textColor: busColor
                )
                
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
    }
    
    private func layoutPathContentContainer(subPaths: [MakchaSubPath]) {
        pathsContentView.subviews.forEach { $0.removeFromSuperview() }
        pathsContentView.flex.direction(.row).define {
            $0.addItem(layoutPathInfo(with: subPaths))
        }
        .paddingHorizontal(24)
        pathsContentView.flex.markDirty()
    }
}

// MARK: 경로 레이아웃 작성하는 코드가 길어져서 분리
extension MainCollectionCell {
    typealias LayoutPathInfoCommonParameter = (isLastPath: Bool, distance: CGFloat, icon: UIImage?)
    typealias LayoutPathInfoBusParameter = (LayoutPathInfoCommonParameter, busType: BusRouteType, subPath: MakchaSubPath)
    typealias LayoutPathInfoSubwayParameter = (LayoutPathInfoCommonParameter, subwayType: SubwayCode, subPath: MakchaSubPath)
    
    private func layoutPathInfoWalk(_ flex: Flex, params: LayoutPathInfoCommonParameter) {
        let (isLastPath, distance, icon) = (params)
        
        let bgColor = UIColor.cf(.grayScale(.gray500))
        let iconTintColor = UIColor.cf(.grayScale(.gray300))
        let iconBgColor = UIColor.cf(.grayScale(.gray50))
        let iconBorderColor = UIColor.cf(.grayScale(.white))
        
        let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
        imageView.contentMode = .center
        
        flex.addItem().direction(.row).alignItems(.end).define {
            $0.addItem()
                .width(distance - 12).height(10)
                .backgroundColor(bgColor)
                .cornerRadius(5)
                .marginBottom(7)
                .marginLeft(isLastPath ? 0 : 12)
                .marginRight(isLastPath ? 12 : 0)
            $0.addItem().position(.absolute).define {
                $0.addItem(imageView)
                    .width(24).height(24)
                    .backgroundColor(iconBgColor)
                    .border(1, iconBorderColor)
                    .cornerRadius(12)
            }
            .left(isLastPath ? CGFloat(distance - 24) : 0)
        }
        .minWidth(24)
    }
    
    private func layoutPathInfoBus(_ flex: Flex, params: LayoutPathInfoBusParameter) {
        let ((_, distance, icon), busType, subPath) = params
        
        let bgColor = busType.busUIColor
        let distanceBgColor = UIColor(busType.busColor.opacity(0.6))
        let iconTintColor = UIColor.cf(.grayScale(.white))
        
        let stationName = subPath.stations?.first?.name ?? "Undefined"
        let time = "+\(subPath.time)분"
        
        let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
        imageView.contentMode = .center
        
        flex.addItem().direction(.row).alignItems(.end).define {
            $0.addItem()
                .width(distance).height(10)
                .backgroundColor(distanceBgColor)
                .cornerRadius(5)
                .marginBottom(7)
                .marginLeft(12)
                .marginRight(0)
            $0.addItem().position(.absolute).define {
                let textContainerView = UIView()
                let arrivalStationContainer = UIView()
                let arriveTimeLabel = UILabelFactory.build(
                    attributedText: .pretendard(time, scale: .caption),
                    textColor: .cf(.grayScale(.gray600))
                )
                let arrivalStationLabel = UILabelFactory.build(
                    attributedText: .pretendard(stationName, scale: .body),
                    textColor: .cf(.grayScale(.gray800))
                )
                arrivalStationLabel.lineBreakMode = .byTruncatingTail
                arrivalStationLabel.numberOfLines = 1
                
                var textContainerWidth: CGFloat = .zero
                
                $0.addItem(textContainerView).position(.absolute).define {
                    $0.addItem(arriveTimeLabel).width(100%)
                    $0.addItem(arrivalStationContainer).direction(.row).define {
                        $0.addItem(arrivalStationLabel).maxWidth(80)
                        
                        guard let lane = subPath.lane else { return }
                        // 동일한 노선의 버스 리스트
                        for lan in lane {
                            let transportLabel = UILabelFactory.build(
                                attributedText: .pretendard(lan.name, scale: .caption2),
                                textColor: bgColor
                            )
                            $0.addItem(transportLabel)
                                .border(1, bgColor)
                                .padding(.cfRadius(.xxxsmall))
                                .cornerRadius(.cfRadius(.xxxsmall))
                                .marginLeft(4)
                        }
                    }
                    
                    // label 길이에 따라 레이아웃 변경
                    textContainerWidth = arrivalStationLabel.intrinsicContentSize.width
                    textContainerWidth = min(textContainerWidth, 80)

                    $0.width(textContainerWidth)
                }
                .left(-(textContainerWidth / 2) + 12).bottom(24)
                
                // IconContainer
                $0.addItem().define {
                    $0.addItem(imageView)
                        .width(24).height(24)
                        .backgroundColor(bgColor)
                        .cornerRadius(12)
                        .border(1, .cf(.grayScale(.white)))
                }
            }
        }
    }
    
    private func layoutPathInfoSubway(_ flex: Flex, params: LayoutPathInfoSubwayParameter) {
        let ((_, distance, icon), subwayType, subPath) = params
        
        let bgColor = subwayType.subWayUIColor
        let distanceBgColor = UIColor(subwayType.subwayColor.opacity(0.6))
        let iconTintColor = UIColor.cf(.grayScale(.white))
        let stationName = "\(subPath.stations?.first?.name ?? "undefined")역"
        let time = "+\(subPath.time)분"
        
        flex.addItem().direction(.row).alignItems(.end).define {
            $0.addItem()
                .width(distance).height(10)
                .backgroundColor(distanceBgColor)
                .cornerRadius(5)
                .margin(0, 12, 7, 0)
            $0.addItem().position(.absolute).define {
                let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
                imageView.contentMode = .center
                
                let textContainerView = UIView()
                let arrivalStationContainer = UIView()
                let arrivalStationLabel = UILabelFactory.build(
                    text: stationName,
                    textColor: .cf(.grayScale(.gray800))
                )
                let arriveTimeLabel = UILabelFactory.build(
                    text: time,
                    textScale: .caption,
                    textColor: .cf(.grayScale(.gray600))
                )
                // TextContainer
                var textContainerWidth: CGFloat = .zero
                
                $0.addItem(textContainerView).position(.absolute).define {
                    $0.addItem(arriveTimeLabel).width(100%)
                    $0.addItem(arrivalStationContainer).define {
                        $0.addItem(arrivalStationLabel).width(100%)
                    }
                    .width(100%)
                    
                    // label 길이에 따라 레이아웃 변경
                    textContainerWidth = arrivalStationLabel.intrinsicContentSize.width
                }
                .left(-(textContainerWidth / 2) + 12).bottom(24)
                // IconContainer
                $0.addItem().define {
                    $0.addItem(imageView)
                        .width(24).height(24)
                        .backgroundColor(bgColor)
                        .border(1, .cf(.grayScale(.white)))
                        .cornerRadius(12)
                }
            }
        }
    }
}

#if DEBUG
struct MainCollectionCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = MainCollectionCell()
        let data: MakchaCellData = (MakchaInfo.mockMakchaInfo.makchaPaths.last!, (ArrivalStatus.arriveSoon, ArrivalStatus.arriveSoon))
        ViewPreview {
            cell.configure(with: data)
            return cell
        }
    }
}
#endif
// swiftlint: enable file_length
