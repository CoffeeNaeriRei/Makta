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
import Reusable

final class SettingsView: UIView {
    private let rootView = UIView()
    
    let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
//        backgroundColor = .cf(.grayScale(.white))
        backgroundColor = .cf(.grayScale(.gray100))
        settingsTableView.register(cellType: UITableViewCell.self)
        
        rootView.flex.define {
            $0.addItem(settingsTableView).grow(1)
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
