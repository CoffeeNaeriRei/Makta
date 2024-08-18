//
//  SplashView.swift
//  Makta
//
//  Created by yuncoffee on 8/18/24.
//

import Foundation
import SwiftUI

import FlexLayout
import PinLayout

final class SplashView: UIView {
    private let rootView = UIView()
    private let imageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .splash)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .splashBackground
        
        rootView.flex.justifyContent(.center).alignItems(.center).define {
            $0.addItem(imageView)
                .maxWidth(50%)
        }
        
        addSubview(rootView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootView.pin.all()
        rootView.flex.layout()
        
    }
}
