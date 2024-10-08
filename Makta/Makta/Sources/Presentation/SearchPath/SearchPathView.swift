//
//  SearchPathView.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import FlexLayout
import PinLayout

final class SearchPathView: UIView {
    private let rootView = UIView()
    
    private let titleLabel = UILabelFactory.build(
        text: "경로 정보",
        textScale: .title3,
        textAlignment: .left,
        textColor: .cf(.grayScale(.gray900))
    )
        
    private let titleContainer = UIView()
    private let textFieldContainer = UIView()
    private let searchInfoContainer = UIView()
    private let searchResultScrollView = UIScrollView()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.isHidden = true
        
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.setTitleColor(.cf(.grayScale(.white)), for: .normal)
        button.tintColor = .cf(.grayScale(.white))
        button.semanticContentAttribute = .forceRightToLeft
        
        return button
    }()
    
    let startPointLabel = {
        let label = UILabel()
        label.attributedText = .pretendard("test", scale: .title)
        label.textColor = UIColor.cf(.colorScale(.blue(.mediumLight)))
        
        return label
    }()
    
    let startPointTextField: UITextField = {
        let textField = CustomUITextField()
        textField.font = .pretendard(.regular, size: 14)
        textField.placeholder = "출발지를 입력해주세요."
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    let destinationPointTextField: UITextField = {
        let textField = CustomUITextField()
        textField.font = .pretendard(.regular, size: 14)
        textField.placeholder = "도착지를 입력해주세요."
        textField.clearButtonMode = .whileEditing

        return textField
    }()
    
    let resetStartPointButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = UIColor.cf(.grayScale(.black))
        
        return button
    }()
    
    let resetDestinationPointButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = UIColor.cf(.grayScale(.black))
        
        return button
    }()
    
    // 검색 결과를 표시할 테이블 뷰
    let searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.cf(.grayScale(.gray500))
        tableView.backgroundColor = .background
        
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
        backgroundColor = .background
        
        searchResultTableView.register(cellType: SearchResultCell.self) // 테이블 뷰 재사용 셀 등록
        rootView.flex.define {
            // titleContainer
            $0.addItem(titleContainer).direction(.row).justifyContent(.spaceBetween).define {
                $0.addItem(titleLabel)
                $0.addItem(closeButton)
            }
            .padding(14, 16, 12)
            // textFieldContainer
            $0.addItem(textFieldContainer).gap(8).define {
                for idx in 0..<2 {
                    let label = UILabelFactory.build(
                        text: idx == 0 ? "출발지" : "도착지",
                        textScale: .caption,
                        textColor: .cf(.grayScale(.gray500))
                    )
                    
                    let textField = idx == 0 ? startPointTextField : destinationPointTextField
                    let resetButton = idx == 0 ? resetStartPointButton : resetDestinationPointButton
                    
                    $0.addItem().gap(8).direction(.row).alignItems(.center).define {
                        $0.addItem().direction(.row).gap(8).define {
                            $0.addItem(label)
                            $0.addItem(textField)
                                .minHeight(36)
                                .cornerRadius(4)
                                .grow(1)
                        }
                        .grow(1)
                        $0.addItem(resetButton)
                    }
                }
            }
            .padding(8, 16, 20)
            
            // searchInfoContainer
            $0.addItem(searchInfoContainer).define {
                $0.addItem(searchResultScrollView).direction(.column).define {
//                    // 검색 결과 상단 구분선
                    $0.addItem()
                        .width(100%).height(.cfStroke(.xsmall))
                        .backgroundColor(UIColor.cf(.grayScale(.gray500)))
                    $0.addItem(searchResultTableView)
                }
                .grow(1)
                
                $0.addItem(searchButton)
                    .backgroundColor(.test)
                    .minHeight(56)
                    .cornerRadius(28)
                    .marginHorizontal(16)

            }
            .grow(1)
            .backgroundColor(.background)
        }
        
        addSubview(rootView)
    }
    
    private func layout() {
        rootView.pin.all()
        rootView.flex.layout()

        searchResultTableView.frame.size.height = searchResultScrollView.bounds.size.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
}

extension SearchPathView {
    enum Detent {
        case custom
        case large
        
        var title: String {
            switch self {
            case .custom:
                "경로 정보"
            case .large:
                "경로 검색"
            }
        }
    }
    
    func configure(_ detent: SearchPathView.Detent) {
        titleLabel.text = detent.title
        closeButton.isHidden = detent == .large ? false : true
        
        let isLargeDetent = (detent == .large)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            // 시트를 올리는 경우, isHidden을 먼저 풀어줘야 함
            if isLargeDetent {
                self.searchInfoContainer.isHidden = false
                self.backgroundColor = .background
                self.searchButton.flex.marginBottom(self.safeAreaInsets.bottom + 16).markDirty()
            }
            self.backgroundColor = .background
            
            self.searchButton.flex.view?.alpha = isLargeDetent ? 1.0 : 0.0
            self.searchInfoContainer.flex.markDirty()
            self.layoutIfNeeded()
        }) { _ in
            // 시트를 닫는 경우, 애니메이션 종료 후 isHidden 처리
            if !isLargeDetent {
                self.searchInfoContainer.flex.view?.isHidden = true
            }
        }
    }
}

#if DEBUG
struct SearchPathView_Preview: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            SearchPathView()
        }
    }
}
#endif
