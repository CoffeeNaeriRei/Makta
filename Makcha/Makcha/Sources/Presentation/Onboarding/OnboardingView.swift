//
//  OnboardingView.swift
//  Makcha
//
//  Created by yuncoffee on 7/23/24.
//

import Foundation
import SwiftUI

import FlexLayout
import PinLayout

final class OnboardingView: UIView {
    private let rootView = UIView()
    var type: OnboardingType = .enterFirst

    // HeaderViews
    private let titleLabel = UILabelFactory.build(
        text: "기본 도착지 설정",
        textScale: .title3
    )
    private let descriptionLabel = UILabelFactory.build(
        text: "경로 탐색 시 사용할 위치 정보를 선택해주세요.",
        textScale: .body
    )
    
    let textField: UITextField = {
        let textField = CustomUITextField()
        textField.setBorder()
        textField.font = .pretendard(.regular, size: 14)
        textField.placeholder = "도착지를 입력해주세요."
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    // 검색 결과를 표시할 테이블 뷰
    let searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.cf(.grayScale(.gray500))
        tableView.backgroundColor = .cf(.grayScale(.white))
        
        return tableView
    }()
    
    // FooterViews
    let footerContainer = UIView()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.tintColor = .cf(.grayScale(.white))
        
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.cf(.grayScale(.gray700)), for: .normal)
        button.tintColor = .cf(.grayScale(.gray700))
        
        return button
    }()
    
    init(_ type: OnboardingType = .enterFirst) {
        super.init(frame: .zero)
        self.type = type
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .background
        searchResultTableView.register(cellType: SearchResultCell.self)
        
        rootView.flex.define {
            /// header
            $0.addItem().gap(12).define {
                $0.addItem().alignItems(.start).gap(8).define {
                    $0.addItem(titleLabel)
                    $0.addItem(descriptionLabel)
                }
                $0.addItem(textField)
                    .minHeight(36)
                    .cornerRadius(4)
                
            }
            .padding(16)
            $0.addItem().height(1).backgroundColor(.cf(.grayScale(.gray400)))
            /// searchField
            $0.addItem(searchResultTableView)
                .backgroundColor(.background)
                .grow(1)
            /// footer
            $0.addItem(footerContainer).gap(16).define {
                $0.addItem(startButton)
                    .minHeight(56)
                    .backgroundColor(.test)
                    .cornerRadius(28)
                if type == .enterFirst {
                    $0.addItem(skipButton)
                        .minHeight(56)
                }
            }
            .padding(16, 16, 0, 16)
            .backgroundColor(.background)
        }
        addSubview(rootView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootView.pin.top(pin.safeArea.top).horizontally(pin.safeArea.left).bottom()
        footerContainer.flex
            .paddingBottom(safeAreaInsets.bottom + 16)
            .markDirty()
        rootView.flex.layout()
    }
}

#if DEBUG
struct OnboardingView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            OnboardingView()
        }
    }
}
#endif
