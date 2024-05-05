//
//  TestView.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

public final class TestView: UIView {
    
    private lazy var customLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Hello UIKit!!"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUI() {
        self.backgroundColor = .white
        
        addSubview(customLabel)
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            customLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

#Preview {
    TestViewController()
}
