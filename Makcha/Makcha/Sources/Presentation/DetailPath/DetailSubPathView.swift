//
//  DetailSubPathView.swift
//  Makcha
//
//  Created by yuncoffee on 6/11/24.
//

import Foundation
import SwiftUI

import MakchaDesignSystem
import FlexLayout
import PinLayout

final class DetailSubPathView: UIView {
    var subPath: MakchaSubPath?
    var totalTime: CGFloat = 0
    
    var delegate: DetailViewDelegate?
    
    private let rootView = UIView()
    private let contentView = UIView()
    private let timeLabel = UILabelFactory.build(
        text: "",
        textScale: .caption,
        textAlignment: .right,
        textColor: .cf(.grayScale(.gray700))
    )
    
    private let expanbaleContainer = {
        let view = DottedLineView()
        view.position = .top
        view.backgroundColor = .cf(.grayScale(.gray50))
        view.lineColor = .cf(.grayScale(.gray200))
        view.lineWidth = 1
        view.lineDashPattern = []
        
        return view
    }()
    
    private let expandableHeaderContainer = {
        let view = DottedLineView()
        view.position = .bottom
        view.backgroundColor = .clear
        view.lineColor = .cf(.grayScale(.gray200))
        view.lineWidth = 1
        view.lineDashPattern = []
        
        return view
    }()
    
    private let expandableBodyContainer = {
        let view = DottedLineView()
        view.position = .bottom
        view.backgroundColor = .clear
        view.lineColor = .cf(.grayScale(.gray200))
        view.lineWidth = 1
        
        return view
    }()
    
    private let decorationContainer = UIView()
    
    private let distanceView = UIView()
    private let toggleButon = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.cf(.grayScale(.gray700)), renderingMode: .alwaysOriginal), for: .normal)
        button.flex.minHeight(24).minWidth(40)
        
        return button
    }()
    
    private var isExpadnable = false
    private var calcedDistance: CGFloat?
    private let DISTANCE_SCALE = 0.5
    
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootView.pin.all()
        rootView.flex.layout(mode: .adjustHeight)
    }
    
    private func setup() {
        rootView.flex.define {
            $0.addItem(contentView)
        }
        
        toggleButon.addAction(.init(handler: { _ in
            self.toggleExpandable()
        }), for: .touchUpInside)
        
        addSubview(rootView)
    }
    
    private func layout() {
        guard let subPath = subPath else { return }
        let subPathType = subPath.subPathType
        let timeRatio = CGFloat(subPath.time) / totalTime
        let uiDistance = max(max(timeRatio * UIScreen.main.bounds.width * 0.5, timeLabel.intrinsicContentSize.height + 8), 48)
        calcedDistance = uiDistance
        switch subPathType {
        case .walk:
            layoutSubPathTypeWalk(distance: uiDistance)
        case .bus:
            layoutSubPathTypeBus(distance: uiDistance)
        case .subway:
            layoutSubPathTypeSubway(distance: uiDistance)
        }
        
        expanbaleContainer.flex.height(24)
        expanbaleContainer.subviews.last?.isHidden = true
        expanbaleContainer.flex.markDirty()
    }
}

// init
extension DetailSubPathView {
    convenience init(subPath: MakchaSubPath, totalTime: Int) {
        self.init()
        configure(subPath: subPath, totalTime: totalTime)
    }
}

// configure
extension DetailSubPathView {
    func configure(subPath: MakchaSubPath, totalTime: Int) {
        // update Layout
        self.subPath = subPath
        self.totalTime = CGFloat(totalTime)
        layout()
    }
}

// layout
extension DetailSubPathView {
    private func layoutSubPathTypeWalk(distance: CGFloat) {
        guard let subPath = subPath else { return }
        let subPathType = subPath.subPathType
        timeLabel.attributedText = .pretendard("\(subPath.time)분", scale: .caption)
        timeLabel.textAlignment = .right
        
        let imageView = pathIconImageView(subPathType)
        let distanceBgColor: UIColor = .cf(.grayScale(.gray600)).withAlphaComponent(0.22)
        
        contentView.flex.define {
            $0.addItem().define {
                $0.addItem(timeLabel).position(.absolute)
                    .top(distance / 2 - timeLabel.intrinsicContentSize.height / 2)
                    .left(-32)
                    .width(37)
                $0.addItem(distanceView)
                    .backgroundColor(distanceBgColor)
                    .width(4).height(distance)
                    .marginLeft(12 - 2)
            }
            .marginLeft(32)
            $0.addItem(imageView)
                .width(24).height(24)
                .cornerRadius(12)
                .marginLeft(32)
        }
    }
    
    private func layoutSubPathTypeBus(distance: CGFloat) {
        guard let subPath = subPath, let transportColor = subPath.lane?.first?.busRouteType?.busUIColor,
              let stations = subPath.stations?.dropFirst().dropLast() else { return }
        let subPathType = subPath.subPathType
        timeLabel.attributedText = .pretendard("\(subPath.time)분", scale: .caption)
        timeLabel.textAlignment = .right
        
        let startImageView = pathIconImageView(subPathType, transportColor)
        let endImageView = pathIconImageView(subPathType, transportColor)
        let distanceBgColor = transportColor.withAlphaComponent(0.22)
        
        let headerTitleLabel = UILabelFactory.build(
            attributedText: .pretendard("\(stations.count + 1)개 정거장 이동", scale: .caption),
            textAlignment: .left,
            textColor: .cf(.grayScale(.gray700))
        )
        
        // MARK: ~행 과 ~ 방면을 구분해서 알 수 있는지?
        let way = "\(subPath.startArsID ?? "")"
        // 도착시간 계산
        // 다음 도착시간?
        let arrivalTime = "NN분 NN초"
        let nextArrivalTime = "NN분"
        
        let wayLabel = UILabelFactory.build(
            text: way,
            textScale: .caption2,
            textColor: .cf(.grayScale(.gray500))
        )
        wayLabel.flex.padding(2, 4)
        
        let arrivalTimeLabel = UILabelFactory.build(
            text: arrivalTime,
            textScale: .caption,
            textColor: .cf(.grayScale(.gray500))
        )
        let nextArrivalTimeLabel = UILabelFactory.build(
            text: nextArrivalTime,
            textScale: .caption,
            textColor: .cf(.grayScale(.gray500))
        )
        
        let dividerLabel2 = UILabelFactory.build(
            text: "|",
            textScale: .caption,
            textColor: .cf(.grayScale(.gray700))
        )
        
        arrivalTimeLabel.flex.padding(2, 4)
        nextArrivalTimeLabel.flex.padding(2, 4)
        
        let startStationLabel = UILabelFactory.build(
            attributedText: .pretendard("\(subPath.startName ?? "시작")", scale: .headline),
            textAlignment: .left,
            textColor: .cf(.grayScale(.gray900))
        )
        
        let endStationLabel = UILabelFactory.build(
            attributedText: .pretendard("\(subPath.endName ?? "끝")", scale: .headline),
            textAlignment: .left,
            textColor: .cf(.grayScale(.gray900))
        )
        
        contentView.flex.define {
            $0.addItem().direction(.row).gap(8).alignItems(.start).define {
                $0.addItem(startImageView)
                    .width(24).height(24)
                    .cornerRadius(12)
                    .marginLeft(32)
                // 방면정보
                $0.addItem().gap(4).define {
                    $0.addItem().direction(.row).alignItems(.end).gap(2).define {
                        $0.addItem(startStationLabel)
                        $0.addItem().direction(.row).gap(2).define {
                            $0.addItem(wayLabel)
                        }
                    }
                    $0.addItem().position(.absolute).define {
                        $0.addItem().direction(.row).gap(2).define {
                            $0.addItem(arrivalTimeLabel)
                            $0.addItem(dividerLabel2)
                            $0.addItem(nextArrivalTimeLabel)
                        }
                    }
                    .top(startImageView.intrinsicContentSize.height + 6)
                }
            }
            $0.addItem().define {
                // Decorations
                $0.addItem(timeLabel)
                    .position(.absolute)
                    .top(distance / 2 - timeLabel.intrinsicContentSize.height / 2)
                    .left(-32)
                    .width(37)
                $0.addItem(distanceView)
                    .backgroundColor(distanceBgColor)
                    .width(4).height(distance)
                    .marginLeft(12 - 2)
                // DropDownContainer
                $0.addItem(expanbaleContainer)
                    .position(.absolute).define {
                        // DropdownHeader
                        $0.addItem(expandableHeaderContainer).direction(.row).justifyContent(.spaceBetween).define {
                            $0.addItem(headerTitleLabel)
                                .marginLeft(12)
                            if !stations.isEmpty {
                                $0.addItem(toggleButon)
                                    .width(24).height(24)
                            }
                        }
                        .grow(1)
                        // DropDown Body
                        $0.addItem(expandableBodyContainer).define {
                            for station in stations {
                                let stationLabel = UILabelFactory.build(
                                    text: "\(station.name)",
                                    textAlignment: .left,
                                    textColor: .cf(.grayScale(.gray600))
                                )
                                $0.addItem().direction(.row).alignItems(.center).define {
                                    $0.addItem()
                                        .width(8).height(8)
                                        .cornerRadius(4)
                                        .backgroundColor(.white)
                                        .border(1, transportColor)
                                        .left(-24)
                                    $0.addItem(stationLabel)
                                        .left(-8)
                                        .margin(4, 20, 4)
                                }
                                .minHeight(28)
                            }
                        }
                    }
                    .width(UIScreen.main.bounds.width - 64).minHeight(24)
                    .top(arrivalTimeLabel.intrinsicContentSize.height + 6).left(32)
                
            }
            .marginLeft(32)
            $0.addItem().direction(.row).gap(8).define {
                $0.addItem(endImageView)
                    .width(24).height(24)
                    .cornerRadius(12)
                    .marginLeft(32)
                $0.addItem(endStationLabel)
            }
        }
    }
    
    private func layoutSubPathTypeSubway(distance: CGFloat) {
        guard let subPath = subPath, let transportColor = subPath.lane?.first?.subwayCode?.subWayUIColor, let stations = subPath.stations?.dropFirst().dropLast() else { return }
        let subPathType = subPath.subPathType
        timeLabel.attributedText = .pretendard("\(subPath.time)분", scale: .caption)
        timeLabel.textAlignment = .right
        let startImageView = pathIconImageView(subPathType, transportColor)
        let endImageView = pathIconImageView(subPathType, transportColor)
        let distanceBgColor = transportColor.withAlphaComponent(0.22)
        
        let headerTitleLabel = UILabelFactory.build(
            attributedText: .pretendard("\(stations.count + 1)개 역 이동", scale: .caption),
            textAlignment: .left,
            textColor: .cf(.grayScale(.gray700))
        )
        
        // MARK: ~행 과 ~ 방면을 구분해서 알 수 있는지?
        let way = "\(subPath.way ?? "")행"
        let detailWay = "\(subPath.nextSt ?? "")역 방면"
        // 도착시간 계산
        // 다음 도착시간?
        let arrivalTime = "NN분 NN초"
        let nextArrivalTime = "NN분"
        
        let wayLabel = UILabelFactory.build(
            text: way,
            textScale: .caption2,
            textColor: .cf(.grayScale(.gray500))
        )
        let detailWayLabel = UILabelFactory.build(
            text: detailWay,
            textScale: .caption2,
            textColor: .cf(.grayScale(.gray500))
        )
        
        let dividerLabel = UILabelFactory.build(
            text: "|",
            textScale: .caption,
            textColor: .cf(.grayScale(.gray700))
        )
        wayLabel.flex.padding(2, 4)
        detailWayLabel.flex.padding(2, 4)
        
        let arrivalTimeLabel = UILabelFactory.build(
            text: arrivalTime,
            textScale: .caption,
            textColor: .cf(.grayScale(.gray500))
        )
        let nextArrivalTimeLabel = UILabelFactory.build(
            text: nextArrivalTime,
            textScale: .caption,
            textColor: .cf(.grayScale(.gray500))
        )
        
        let dividerLabel2 = UILabelFactory.build(
            text: "|",
            textScale: .caption,
            textColor: .cf(.grayScale(.gray700))
        )
        
        arrivalTimeLabel.flex.padding(2, 4)
        nextArrivalTimeLabel.flex.padding(2, 4)
        
        let startStationLabel = UILabelFactory.build(
            attributedText: .pretendard("\(subPath.startName ?? "시작")역", scale: .headline),
            textAlignment: .left,
            textColor: .cf(.grayScale(.gray900))
        )
        
        let endStationLabel = UILabelFactory.build(
            attributedText: .pretendard("\(subPath.endName ?? "끝")역", scale: .headline),
            textAlignment: .left,
            textColor: .cf(.grayScale(.gray900))
        )
        
        contentView.flex.define {
            $0.addItem().direction(.row).gap(8).alignItems(.start).define {
                $0.addItem(startImageView)
                    .width(24).height(24)
                    .cornerRadius(12)
                    .marginLeft(32)
                // 방면정보
                $0.addItem().gap(4).define {
                    $0.addItem().direction(.row).alignItems(.end).gap(2).define {
                        $0.addItem(startStationLabel)
                        $0.addItem().direction(.row).gap(2).define {
                            $0.addItem(wayLabel)
                            $0.addItem(dividerLabel)
                            $0.addItem(detailWayLabel)
                        }
                    }
                    $0.addItem().position(.absolute).define {
                        $0.addItem().direction(.row).gap(2).define {
                            $0.addItem(arrivalTimeLabel)
                            $0.addItem(dividerLabel2)
                            $0.addItem(nextArrivalTimeLabel)
                        }
                    }
                    .top(startImageView.intrinsicContentSize.height + 6)
                }
                
            }
            $0.addItem().define {
                // Decorations
                $0.addItem(timeLabel)
                    .position(.absolute)
                    .top(distance / 2 - timeLabel.intrinsicContentSize.height / 2)
                    .left(-32)
                    .width(37)
                $0.addItem(distanceView)
                    .backgroundColor(distanceBgColor)
                    .width(4).height(distance)
                    .marginLeft(12 - 2)
                // DropDownContainer
                $0.addItem(expanbaleContainer)
                    .position(.absolute).define {
                        // DropdownHeader
                        $0.addItem(expandableHeaderContainer).direction(.row).justifyContent(.spaceBetween).define {
                            $0.addItem(headerTitleLabel)
                                .marginLeft(12)
                            if !stations.isEmpty {
                                $0.addItem(toggleButon)
                                    .width(24).height(24)
                            }
                        }
                        .grow(1)
                        // DropDown Body
                        $0.addItem(expandableBodyContainer).define {
                            for station in stations {
                                let stationLabel = UILabelFactory.build(
                                    text: "\(station.name)",
                                    textAlignment: .left,
                                    textColor: .cf(.grayScale(.gray600))
                                )
                                $0.addItem().direction(.row).alignItems(.center).define {
                                    $0.addItem()
                                        .width(8).height(8)
                                        .cornerRadius(4)
                                        .backgroundColor(.white)
                                        .border(1, transportColor)
                                        .left(-24)
                                    $0.addItem(stationLabel)
                                        .left(-8)
                                        .margin(4, 20, 4)
                                }
                                .minHeight(28)
                            }
                        }
                    }
                    .width(UIScreen.main.bounds.width - 64).minHeight(24)
                    .top(arrivalTimeLabel.intrinsicContentSize.height + 6).left(32)
                
            }
            .marginLeft(32)
            $0.addItem().direction(.row).gap(8).define {
                $0.addItem(endImageView)
                    .width(24).height(24)
                    .cornerRadius(12)
                    .marginLeft(32)
                $0.addItem(endStationLabel)
            }
        }
    }
}

extension DetailSubPathView {
    private func pathIconImageView(
        _ type: SubPathType,
        _ transportColor: UIColor? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .regular,
            scale: .default
        )
        
        let (tintColor, bgColor, borderColor) = pathIconColor(type)
        
        let icon = UIImage(
            systemName: type.iconName,
            withConfiguration: symbolConfig
        )?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        
        imageView.image = icon
        imageView.contentMode = .center
        
        imageView.flex
            .backgroundColor(transportColor ?? bgColor)
            .border(1, borderColor)
        
        return imageView
    }
    
    private func pathIconColor(_ subPathType: SubPathType) -> (tintColor: UIColor, bgColor: UIColor, borderColor: UIColor) {
        switch subPathType {
        case .walk:
            (
                UIColor.cf(.grayScale(.gray300)),
                UIColor.cf(.grayScale(.gray50)),
                UIColor.cf(.grayScale(.gray100))
            )
        case .bus:
            (
                UIColor.cf(.grayScale(.white)),
                UIColor.cf(.grayScale(.gray50)),
                UIColor.cf(.grayScale(.white))
            )
        case .subway:
            (
                UIColor.cf(.grayScale(.white)),
                UIColor.cf(.grayScale(.gray50)),
                UIColor.cf(.grayScale(.white))
            )
        }
    }
}

extension DetailSubPathView {
    private func toggleExpandable() {
        let toggleImage = UIImage(
            systemName: isExpadnable
            ? "chevron.down"
            : "chevron.up")?
            .withTintColor(
                .cf(.grayScale(.gray700)),
                renderingMode: .alwaysOriginal
            )
        
        if isExpadnable {
            expanbaleContainer.flex.height(24)
            expanbaleContainer.lineDashPattern = []
            expandableHeaderContainer.lineDashPattern = []
            expandableHeaderContainer.lineWidth = 1
            distanceView.flex.height(calcedDistance)
            
            timeLabel.flex.top(calcedDistance! / 2 - timeLabel.intrinsicContentSize.height / 2)
        } else {
            let expandableHeight = expandableBodyContainer.bounds.height + 44
            expanbaleContainer.flex.height(.infinity)
            expanbaleContainer.lineDashPattern = [4]
            expandableHeaderContainer.lineWidth = 0
            distanceView.flex.height(expandableHeight)
            
            timeLabel.flex.top(expandableHeight / 2 - timeLabel.intrinsicContentSize.height / 2)
        }
        isExpadnable.toggle()
        toggleButon.setImage(toggleImage, for: .normal)
        toggleButon.flex.markDirty()
        distanceView.flex.markDirty()
        expandableBodyContainer.isHidden.toggle()
        expanbaleContainer.flex.markDirty()
        delegate?.didSubPathViewHeightChange()
        setNeedsLayout()
    }
}

#if DEBUG
struct DetailSubPathView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            let subPath = MakchaInfo.mockMakchaInfo.makchaPaths.last?.subPath[1]
            let totalTime = MakchaInfo.mockMakchaInfo.makchaPaths.first?.totalTime
            
            guard let subPath = subPath, let totalTime = totalTime else {
                return DetailSubPathView()
            }
            return DetailSubPathView(subPath: subPath, totalTime: totalTime)
        }
    }
}
#endif
