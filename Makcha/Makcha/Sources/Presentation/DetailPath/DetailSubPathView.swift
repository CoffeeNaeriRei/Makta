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
    
    private let DISTANCE_SCALE = 0.5
    
    private let rootView = UIView()
    private let contentView = UIView()
    
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
        .minHeight(80)
        
        addSubview(rootView)
    }
    
    private func layout() {
        guard let subPath = subPath else { return }
        let subPathType = subPath.subPathType
        switch subPathType {
        case .walk:
            layoutSubPathTypeWalk()
        case .bus:
            layoutSubPathTypeBus()
        case .subway:
            layoutSubPathTypeSubway()
        }
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

extension DetailSubPathView {
    private func layoutSubPathTypeWalk() {
        guard let subPath = subPath else { return }
        let subPathType = subPath.subPathType
        
        let distanceBgColor: UIColor = .cf(.grayScale(.gray600))
        let iconTintColor: UIColor = .cf(.grayScale(.gray300))
        let iconBorderColor: UIColor = .cf(.grayScale(.gray100))
        let iconBgColor: UIColor = .cf(.grayScale(.gray50))
        
        let timeRatio = CGFloat(subPath.time) / totalTime
        
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .regular,
            scale: .default
        )
        let icon = UIImage(
            systemName: subPathType.iconName,
            withConfiguration: symbolConfig
        )?.withTintColor(iconTintColor, renderingMode: .alwaysOriginal)

        imageView.image = icon
        imageView.contentMode = .center
        

        let timeLabel = UILabelFactory.build(
            text: "\(subPath.time)분",
            textScale: .caption,
            textAlignment: .right,
            textColor: .cf(.grayScale(.gray700))
        )
        
        let uiDistance = max(CGFloat(subPath.distance) * timeRatio * DISTANCE_SCALE, timeLabel.intrinsicContentSize.height + 8)
        
        contentView.flex.define {
            $0.addItem().define {
                $0.addItem(timeLabel).position(.absolute)
                    .top(uiDistance / 2 - timeLabel.intrinsicContentSize.height / 2)
                    .left(-32)
                    .width(37)
                $0.addItem()
                    .backgroundColor(distanceBgColor)
                    .width(4).height(uiDistance)
                    .marginLeft(12 - 2)
            }
            .marginLeft(32)
            $0.addItem(imageView)
                .backgroundColor(iconBgColor)
                .border(1, iconBorderColor)
                .width(24).height(24)
                .cornerRadius(12)
                .marginLeft(32)
        }
    }
    
    private func layoutSubPathTypeBus() {
        
    }
    
    private func layoutSubPathTypeSubway() {
        
    }
}


struct DetailSubPathView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            let subPath = MakchaInfo.mockMakchaInfo.makchaPaths.first?.subPath[0]
            let totalTime = MakchaInfo.mockMakchaInfo.makchaPaths.first?.totalTime
            
            guard let subPath = subPath, let totalTime = totalTime else {
                return DetailSubPathView()
            }
            return DetailSubPathView(subPath: subPath, totalTime: totalTime)
        }
    }
}
