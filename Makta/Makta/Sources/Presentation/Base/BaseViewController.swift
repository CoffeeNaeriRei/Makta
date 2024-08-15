//
//  BaseViewController.swift
//  Makcha
//
//  Created by 김영빈 on 5/10/24.
//

// MARK: - ViewController에 공통적으로 필요한 항목들의 인터페이스를 정의

protocol BaseViewController {
    
    func setupView()
    func bind()
}
