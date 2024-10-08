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
import RxSwift

final class MainCollectionCell: UICollectionViewCell {
    private let MIN_HEIGHT = 200.0
    var cellHeight = 200.0
    
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
        textColor: .cf(.grayScale(.gray600))
    )
    
    private let centerContentsTopLabel = UILabelFactory.build(
        attributedText: .pretendard("도착 예정", scale: .caption),
        textColor: .cf(.grayScale(.gray600))
    )
    
    private let pathScrollView = UIScrollView()
    private let pathsContentView = ContentView()
    private let centerContentsTopContainer = UIView()
    private let nextArrivalTransportTimeContainer = UIView()
    private let subPathInfoContainer = UIView()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .init(width: 0, height: 0)
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOpacity = 0.05
        
        contentView.flex.define {
            /// TopContents
            $0.addItem().define {
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
                        .height(36)
                        .marginTop(12)
                    $0.addItem(nextArrivalTransportTimeContainer).define {
                        $0.addItem(nextArrivalTransportTimeLabel)
                    }
                    .marginTop(4)
                }
                .position(.absolute).top(64)
                /// BottomContents
                $0.addItem().define {
                    $0.addItem(pathsContentView)
                        .minWidth(100%)
                        .alignSelf(.center)
                        .marginBottom(12)
                }
                .position(.absolute).bottom(0)
                .width(100%)
                /// BottomLine
                $0.addItem()
                    .height(.cfStroke(.xsmall))
                    .backgroundColor(.cf(.grayScale(.gray400)))
                    .margin(0, 16)
            }
            .minHeight(200)
            // 서브패스 인포
            $0.addItem(subPathInfoContainer)
                .grow(1)
        }
        .backgroundColor(.background)
        .cornerRadius(12)
        .width(100%)
        .maxWidth(UIScreen.main.bounds.width - 16)
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
        let pathType = data.makchaPath.makchaPathType.rawValue
        pathTypelabel.text = data.makchaPath.fastest ? "가장 빠른 경로" : pathType
        pathTypelabel.flex.markDirty()
        
        // 경로 별 height 계산
        calcSubPathsHeight(with: data.makchaPath.subPath)
        // 상단 시간정보 업데이트
        layoutTopContentsContainer(data.makchaPath.arrivalTime.endPointTimeString)
        // 도착 예정 시간 레이아웃 업데이트
        layoutCenterContentsTopContainer(
            totalTime: data.makchaPath.totalTime,
            firstSubPath: data.makchaPath.subPath.filter { $0.subPathType != .walk }.first
        )
        // 타이머 도착 예정 시간 업데이트
        currentArrivalTransportTimeLabel.attributedText = .repet(data.arrival.first.status.arrivalMessageFirst, size: 36, alt: .bold)
        currentArrivalTransportTimeLabel.flex.markDirty()
        nextArrivalTransportTimeLabel.attributedText = .repet(data.arrival.second.status.arrivalMessageSecond, size: 14)
        nextArrivalTransportTimeLabel.flex.markDirty()
        // 경로 업데이트
        layoutPathContentContainer(subPaths: data.makchaPath.subPath)
        // 레이아웃 갱신
        layoutHeight()
        setNeedsLayout()
    }

    func layoutHeight() {
        contentView.flex.height(cellHeight)
    }
    
    private func calcSubPathsHeight(with data: [MakchaSubPath]) {
        let CONTAINER_PADDING = 8.0

        let subPaths = data.filter { $0.subPathType != .walk }

        var defaultHeight: CGFloat = MIN_HEIGHT
        var pathLineHeight: CGFloat = 0
        // 1. 컨테이너 패딩을 더한다.
        defaultHeight += CONTAINER_PADDING * 2
        // 2. 서브 패스의 전체 높이를 더한다.
        defaultHeight += subPaths.map { _ in 36.0 }.reduce(0) { $0 + $1 }
        // 3. 서브 패스 사이의 패딩 값을 더한다.
        defaultHeight += subPaths.count < 2 ? .zero : Double((subPaths.count - 1)) * CONTAINER_PADDING

        pathLineHeight = defaultHeight - MIN_HEIGHT - CONTAINER_PADDING * 2
        
        if subPaths.last?.subPathType == .bus {
            defaultHeight += CONTAINER_PADDING * 2
        }
        defaultHeight += .cfStroke(.xsmall) * 2
        cellHeight = defaultHeight
        // 컨테이너 내 모든 자식 뷰 제거
        subPathInfoContainer.subviews.forEach { $0.removeFromSuperview() }
        
        subPathInfoContainer.flex.gap(CONTAINER_PADDING).define {
            $0.addItem().position(.absolute)
                .width(100%).height(100%)
                .backgroundColor(.subpathContainer)
                .cornerRadius(12)
            $0.addItem().position(.absolute)
                .width(2).height(pathLineHeight)
                .top(CONTAINER_PADDING).left(CONTAINER_PADDING * 4 + 1)
                .backgroundColor(.cf(.grayScale(.gray500)))
            $0.addItem().marginTop(CONTAINER_PADDING)
            for (idx, subPath) in subPaths.enumerated() {
                let type = subPath.subPathType
                let imageView = UIImageView()
                
                let symbolConfig = UIImage.SymbolConfiguration(
                    pointSize: 10,
                    weight: .regular,
                    scale: .default
                )

                switch type {
                case .walk:
                    break
                case .bus:
                    let icon = UIImage(systemName: type.iconName)?.withConfiguration(symbolConfig)
                    imageView.image = icon?.withTintColor(.cf(.utils(.AlwaysWhite)), renderingMode: .alwaysOriginal)
                    imageView.contentMode = .center
                    
                    guard let busType = subPath.lane?.first?.busRouteType else { return }
                    
                    $0.addItem().direction(.row).define {
                        // imageContainer
                        $0.addItem(imageView)
                            .width(20).height(20)
                            .cornerRadius(10)
                            .border(1, .cf(.grayScale(.white)))
                            .backgroundColor(busType.busUIColor)
                        // textContainer
                        $0.addItem().gap(2).define {
                            let label = UILabelFactory.build(text: subPath.startName ?? "", textAlignment: .left)
                            $0.addItem(label)
                            $0.addItem().direction(.row).gap(8).define {
                                if let lane = subPath.lane?.prefix(3) {
                                    for lan in lane {
                                        let label = UILabelFactory.build(text: lan.name, textScale: .caption, textColor: busType.busUIColor)
                                        
                                        $0.addItem(label)
                                            .border(1, busType.busUIColor)
                                            .cornerRadius(2)
                                            .paddingHorizontal(4)
                                    }
                                }
                            }
                        }
                        .marginTop(2).marginLeft(8)
                    }
                    .minHeight(36)
                    .padding(0, CONTAINER_PADDING + 16)
                case .subway:
                    let icon = UIImage(systemName: type.iconName)?.withConfiguration(symbolConfig)
                    imageView.image = icon?.withTintColor(.cf(.utils(.AlwaysWhite)), renderingMode: .alwaysOriginal)
                    imageView.contentMode = .center
                    
                    guard let subwayType = subPath.lane?.first?.subwayCode else { return }
                    
                    $0.addItem().direction(.row).define {
                        // imageContainer
                        $0.addItem(imageView)
                            .width(20).height(20)
                            .cornerRadius(10)
                            .border(1, .cf(.grayScale(.white)))
                            .backgroundColor(subwayType.subWayUIColor)
                        // textContainer
                        $0.addItem().define {
                            let label = UILabelFactory.build(text: subPath.startName ?? "", textAlignment: .left)
                            
                            $0.addItem(label)
                        }
                        .marginTop(2).marginLeft(8)
                    }
                    .minHeight(idx == subPaths.count - 1 ? 20 : 36)
                    .padding(0, CONTAINER_PADDING + 16)
                }
            }
            $0.addItem().marginBottom(CONTAINER_PADDING)
//            $0.addItem()
//                .height(.cfStroke(.xsmall))
//                .backgroundColor(.cf(.grayScale(.gray500)))
            
        }
    }
    
    // MARK: 들어오는 경로 데이터에 따라 다르게 뷰를 그리기 위한 메서드
    private func layoutPathInfo(with subPaths:[MakchaSubPath]) -> UIView {
        let rootView = UIView()
        
        // 1. 경로의 전체 길이를 구한다.
        let totalDistance = subPaths.map { CGFloat($0.distance) }.reduce(0) { $0 + $1 }
        let maxWidth = UIScreen.main.bounds.width - 48 - 32
        
        // 2. 경로를 UI길이로 환산하자.
        var uiDistances = subPaths.map {
            max(CGFloat($0.distance) / totalDistance *  maxWidth - 24, 24)}
        let totalUiDistance = uiDistances.reduce(0) {$0 + $1 }

        // 3. 경로 조정
        if totalUiDistance > maxWidth {
            if let maxValue = uiDistances.max(), let idx = uiDistances.firstIndex(of: maxValue) {
                uiDistances[idx] -= totalUiDistance - maxWidth
            }
        }

        rootView.flex.direction(.row).define {
            for subPath in subPaths {
                let isLastPath = subPath.idx == subPaths.count - 1
                let distanceForUI = uiDistances[subPath.idx]
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
        .minHeight(36)
        .marginBottom(12)
        
        return rootView
    }
}

// MARK: 하위 뷰 작성하는 코드가 길어져서 분리
extension MainCollectionCell {
    private func layoutTopContentsContainer(_ text: String) {
        estimatedTimeOfArrivalLabel.text = "\(text) 도착"
        estimatedTimeOfArrivalLabel.flex.markDirty()
    }
    
    private func layoutCenterContentsTopContainer(totalTime: Int, firstSubPath: MakchaSubPath?) {
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
        durationTimeLabel.textAlignment = .left
        durationTimeLabel.flex.markDirty()
        
        // 컨테이너 내 모든 자식 뷰 제거
        centerContentsTopContainer.subviews.forEach { $0.removeFromSuperview() }
        // 컨테이너 뷰 새로 그리기
        centerContentsTopContainer.flex.direction(.row).define {
            $0.addItem(centerContentsTopLabel)
        }
        centerContentsTopContainer.flex.markDirty()
    }
    
    private func layoutPathContentContainer(subPaths: [MakchaSubPath]) {
        pathsContentView.subviews.forEach { $0.removeFromSuperview() }
        
        pathsContentView.flex.direction(.row).define {
            $0.addItem().grow(1)
            $0.addItem(layoutPathInfo(with: subPaths))
            $0.addItem().grow(1)
        }
        
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
        
        let bgColor = UIColor.cf(.grayScale(.gray200))
        let iconTintColor = UIColor.cf(.grayScale(.gray600))
        let iconBgColor = UIColor.cf(.grayScale(.gray200))
        let iconBorderColor = UIColor.cf(.grayScale(.gray200))
        
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
        let ((_, distance, icon), busType, _) = params
        
        let bgColor = busType.busUIColor
        let distanceBgColor = UIColor(busType.busColor.opacity(0.6))
        let iconTintColor = UIColor.cf(.utils(.AlwaysWhite))

        let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
        imageView.contentMode = .center
        
        flex.addItem().direction(.row).alignItems(.end).define {
            $0.addItem()
                .width(distance - 12).height(10)
                .backgroundColor(distanceBgColor)
                .cornerRadius(5)
                .marginBottom(7)
                .marginLeft(12)
                .marginRight(0)
            $0.addItem().position(.absolute).define {
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
        let ((_, distance, icon), subwayType, _) = params
        
        let bgColor = subwayType.subWayUIColor
        let distanceBgColor = UIColor(subwayType.subwayColor.opacity(0.6))
        let iconTintColor = UIColor.cf(.utils(.AlwaysWhite))
        
        flex.addItem().direction(.row).alignItems(.end).define {
            $0.addItem()
                .width(distance - 12).height(10)
                .backgroundColor(distanceBgColor)
                .cornerRadius(5)
                .margin(0, 12, 7, 0)
            $0.addItem().position(.absolute).define {
                let imageView = UIImageView(image: icon?.withTintColor(iconTintColor, renderingMode:  .alwaysOriginal))
                imageView.contentMode = .center
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
        let data: MakchaCellData = (MakchaInfo.mockMakchaInfo.makchaPaths.last!, (RealtimeArrivalInfo(status: .arriveSoon), RealtimeArrivalInfo(status: .arriveSoon)))
        ViewPreview {
            cell.configure(with: data)
            return cell
        }
    }
}
#endif
// swiftlint: enable file_length
