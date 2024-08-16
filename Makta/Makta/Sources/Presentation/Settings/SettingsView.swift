//
//  SettingsView.swift
//  Makcha
//
//  Created by 김영빈 on 8/3/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import FlexLayout
import PinLayout

final class SettingsView: UIView {
    private let rootView = UIView()
    
    let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    private lazy var appVersionLabel = UILabelFactory.build(
        attributedText: getAppVersionNSAttrString(),
        textColor: .cf(.grayScale(.gray600))
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
        settingsTableView.register(cellType: UITableViewCell.self)
        
        rootView.flex.define {
            $0.addItem(settingsTableView).grow(1)
            $0.addItem(appVersionLabel)
        }
        
        addSubview(rootView)
    }
    
    private func layout() {
        rootView.pin.all(pin.safeArea)
        rootView.flex.layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func getAppVersionNSAttrString() -> NSAttributedString {
        if let infoDict = Bundle.main.infoDictionary,
           let currentVersion = infoDict["CFBundleShortVersionString"] as? String {
            return NSAttributedString(string: "앱 버전 \(currentVersion)")
        } else {
            return NSAttributedString(string: "앱 버전 불러오지 못함")
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            return SettingsViewController()
        }
    }
}
#endif
