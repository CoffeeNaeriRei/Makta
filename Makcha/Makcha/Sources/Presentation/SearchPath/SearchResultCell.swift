//
//  SearchResultCell.swift
//  Makcha
//
//  Created by 김영빈 on 6/18/24.
//

import Foundation
import SwiftUI
import UIKit

import MakchaDesignSystem
import FlexLayout
import PinLayout

final class SearchResultCell: UITableViewCell {
    private let resultContentView = UIView()
    
    private let pointName = UILabelFactory.build(
        text: "장소 이름",
        textAlignment: .left,
        textColor: UIColor.cf(.grayScale(.gray900))
    )
    
    private let pointAddress = UILabelFactory.build(
        text: "주소",
        textScale: .caption2,
        textAlignment: .left,
        textColor: UIColor.cf(.grayScale(.gray500))
    )
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.flex.define {
            $0.addItem(resultContentView).define {
                $0.addItem().direction(.column).alignItems(.start).define {
                    $0.addItem(pointName)
                    $0.addItem(pointAddress)
                }
            }
            .padding(12, 20, 8)
        }
        .grow(1)
    }
    
    private func layout() {
        contentView.backgroundColor = .cf(.grayScale(.white))
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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//    }
}

extension SearchResultCell {
    func configure(with data: EndPoint) {
        pointName.text = data.name
        pointAddress.text = data.roadAddressName ?? data.addressName
        pointName.flex.markDirty()
        pointAddress.flex.markDirty()
        setNeedsLayout()
    }
}

#if DEBUG
struct SearchResultCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = SearchResultCell()
        let data = EndPoint.mockSearchedEndpoints.first!
        ViewPreview {
            cell.configure(with: data)
            return cell
        }
    }
}
#endif
